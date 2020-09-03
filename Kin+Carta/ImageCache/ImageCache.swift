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
    static let placeHolderImage = UIImage(named: "userSmall")!
    private let cachedImages = NSCache<NSString, UIImage>()
    
    
    private func image(from url: String) -> UIImage? {
        return cachedImages.object(forKey: url as NSString)
    }
    //MARK: - Load Image from url
    // 
    func loadImage(from url: String, completion: @escaping(Result<UIImage,Error>) -> Void) {
        if let catchedImage = image(from: url) {
            print("returning image cache for url \(url)")
            completion(.success(catchedImage))
            return
        }
        NetworkManager.shared.genericRequest(with: url) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.cachedImages.setObject(image, forKey: url as NSString)
                    completion(.success(image))
                } else {
                    self.cachedImages.setObject(ImageCache.placeHolderImage, forKey: url as NSString)
                    completion(.success(ImageCache.placeHolderImage))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
