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
    
    func loadImage(from url: String, completion: @escaping(Result<UIImage,Error>) -> Void) {
        
        if let catchedImage = image(from: url) {
            
            print("returning image cache for url \(url)")
            completion(.success(catchedImage))
            return
        }
        // if we are here there was no image in store, we have to fetch it from the web
        NetworkManager.shared.fetchUserImage(with: url) { (data) in
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            if let image = UIImage(data: data) {
                self.cachedImages.setObject(image, forKey: url as NSString)
                print("fetching image from internet for url: \(url)")
                completion(.success(image))
            } else {
                self.cachedImages.setObject(ImageCache.placeHolderImage, forKey: url as NSString)
                completion(.success(ImageCache.placeHolderImage))
            }
            return 
        }
        
    }
}
