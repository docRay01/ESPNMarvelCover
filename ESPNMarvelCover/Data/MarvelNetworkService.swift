//
//  MarvelNetworkService.swift
//  MarvelFirsts
//
//  Created by Davis, R. Steven on 4/28/22.
//

import Foundation
import CommonCrypto
import CryptoKit

class MarvelNetworkService {
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
    
    func requestIssue(comicId: String, completionHandler: @escaping(IssueModel) -> Void) {
        let authParams = generateAuthorizationParameters()
        
        guard let url = URL(string: baseMarvelURL + "/comics/" + comicId + "?" + authParams) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data,
                  let topLevel: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let dataDict = topLevel["data"] as? [String: Any],
                  let issue: [String:Any] = (dataDict["results"] as? [[String: Any]])?.first else { return }
            
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
            completionHandler(issueModel)
        }

        task.resume()
    }
        
    private func generateAuthorizationParameters() -> String {
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
        let hash = md5Hash(string: timestamp + privateKey + publicKey)
        
        return "apikey=" + publicKey + "&hash=" + hash + "&ts=" + timestamp
    }
    
    func md5Hash(string: String) -> String {
        let hashDigest = Insecure.MD5.hash(data: string.data(using: .utf8)!)
        return hashDigest.map({String(format: "%02hhx", $0)}).joined()
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
