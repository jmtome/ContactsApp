//
//  ImageCache.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 21/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    static let cache = ImageCache()
    static let placeHolderImage = UIImage(named: "userLarge")!
    private let cachedImages = NSCache<NSString, UIImage>()
    
    
    private func image(from url: String) -> UIImage? {
        return cachedImages.object(forKey: url as NSString)
    }
    //MARK: - Load Image from url
    // 
    func loadImage(from url: String, completion: @escaping(Result<UIImage,Error>) -> Void) {
        if let catchedImage = image(from: url) {
//            print("returning image cache for url \(url)")
            completion(.success(catchedImage))
            return
        }
        NetworkManager.shared.genericRequest(with: url) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.cachedImages.setObject(image, forKey: url as NSString)
                    completion(.success(image))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
                //Everytime it cant load an image, it wont set its cache, therefore it will try again to load it next time the cell is reloaded, here it propagates the error with the completion handler, and the Cells catch it and assign a placeholder image
                //old code below, would, once the url failed, assign a permanent placeholder,
//                self.cachedImages.setObject(ImageCache.placeHolderImage, forKey: url as NSString)
//                completion(.success(ImageCache.placeHolderImage))
            }
        }
    }
}
