//
//  MarvelNetworkService.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 4/28/22.
//

import Foundation
import CommonCrypto
import CryptoKit

class MarvelNetworkService {
    enum IssueResponse {
        case success(issue: IssueModel)
        case failure
        case error(error: Error)
    }
    
    private let privateKey: String
    private let publicKey: String
    private let baseMarvelURL = "https://gateway.marvel.com/v1/public"
    
    public static let charactersRequestSize = 100
    
    init() {
        guard let fileUrl = Bundle(for: type(of: self)).url(forResource: "AppSecret", withExtension: "json"),
              let data = try? Data.init(contentsOf: fileUrl),
              let secretsDict = try? JSONDecoder().decode([String: String].self, from: data),
              let privateKey = secretsDict["privateKey"],
              let publicKey = secretsDict["publicKey"] else {
            self.privateKey = "error"
            self.publicKey = "error"
            return
        }
        
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    func requestIssue(comicId: String, completionHandler: @escaping(IssueResponse) -> Void) {
        let authParams = generateAuthorizationParameters()
        
        guard let url = URL(string: baseMarvelURL + "/comics/" + comicId + "?" + authParams) else {
            completionHandler(.failure)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.error(error: error))
                return
            }
            
            guard let issueModel = self.parseIssue(comicId: comicId, data: data) else {
                completionHandler(.failure)
                return
            }
            
            completionHandler(.success(issue: issueModel))
        }

        task.resume()
    }
    
    func parseIssue(comicId: String, data: Data?) -> IssueModel? {
        guard let data = data,
              let topLevel: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let dataDict = topLevel["data"] as? [String: Any],
              let issue: [String:Any] = (dataDict["results"] as? [[String: Any]])?.first else { return nil }
        
        let title: String? = issue["title"] as? String
        var description: String? = issue["description"] as? String
        if description?.isEmpty ?? false {
            // look for the solicit text in the text blob and use that
            // Test with comicId 356 (`4` Issue #1) to see this working
            if let textBlob = issue["textObjects"] as? [[String: String]] {
                for textDict in textBlob {
                    if textDict["type"] == "issue_solicit_text",
                       let solicitText = textDict["text"] {
                        description = solicitText
                    }
                }
            }
        }
        
        let imagePath: [String: String]? = issue["thumbnail"] as? [String: String]
        let imageUrl = self.imageURLFromImagePath(imagePath: imagePath, size: .large)

        let issueModel: IssueModel = IssueModel(id: comicId,
                                                name: title,
                                                imageURLString: imageUrl,
                                                description: description)
        //print(issueModel.name + " | " + (issueModel.imageURLString ?? "no image"))
        return issueModel
    }
    
    private func generateAuthorizationParameters() -> String {
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
        let hash = Insecure.MD5.stringHash(string: timestamp + privateKey + publicKey)
        
        return "apikey=" + publicKey + "&hash=" + hash + "&ts=" + timestamp
    }
    
    private enum imageSize: String {
        case thumbnail = "standard_medium"
        case large = "portrait_uncanny"
    }
    
    private func imageURLFromImagePath(imagePath: [String: String]?, size: imageSize) -> String? {
        guard let imagePath = imagePath,
              let path = imagePath["path"],
              let type = imagePath["extension"] else {
            return nil
        }
        
        return path  + "/" + size.rawValue + "." + type;
    }
}
