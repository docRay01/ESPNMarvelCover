//
//  ImageLoader.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 5/1/22.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
    private var imageDownloadTask: URLSessionTask?
    private var expectedThumbImage: String?
    private var placeholderImage: UIImage
    
    @Published var loadedImage: UIImage?
    
    init() {
        let rect = CGRect(x: 0, y: 0, width: 633, height: 1024)
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        let image = renderer.image { context in
            context.cgContext.setFillColor(UIColor.gray.cgColor)
            context.cgContext.fill(rect)
        }
        placeholderImage = image
    }
    
    func image(urlString: String) -> UIImage {
        guard let url: URL = URL(string: urlString) else {
            return placeholderImage
        }
        
        if expectedThumbImage == url.absoluteString,
            let loadedImage = loadedImage {
            return loadedImage
        } else if expectedThumbImage == url.absoluteString {
            // image is still loading
            return placeholderImage
        } else {
            downloadImage(url: url)
            return placeholderImage
        }
    }
    
    private func downloadImage(url: URL) {
        if imageDownloadTask != nil {
            imageDownloadTask?.cancel()
            imageDownloadTask = nil
        }
        
        expectedThumbImage = url.absoluteString
        loadedImage = nil
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] possibleData, possibleResponse, possibleError in
            guard let self = self else { return }
            
            self.imageDownloadTask = nil
            
            if possibleError == nil,
               let data:Data = possibleData,
               let response:URLResponse = possibleResponse,
               response.url?.absoluteString == self.expectedThumbImage {
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            }
        }
        imageDownloadTask = task
        task.resume()
    }

}
