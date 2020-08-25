//
//  NetworkManager.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 10/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Network error enum
enum NetworkError: Error {
    case clientNetworkError
    case serverNetworkError
    case nilDataError
    case dataDecodingError
    case badURL
}
class NetworkManager {
 
    static let shared = NetworkManager()
    
    //This method fetchs and decodes a codable entity
    func fetchRequest<T: Codable>(with urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in

            guard error == nil else {
                completion(.failure(.clientNetworkError))
                return
            }

            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverNetworkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.nilDataError))
                return
            }

            //here i know my data is good, i can just call the completion block and de-couple the data-decoding from the networking class
            
            guard let decodedData: T = self.decodedData(data) else {
                completion(.failure(.dataDecodingError))
                return
            }

            completion(.success(decodedData))
        }
        dataTask.resume()
    }
    
    //This method assumes that the data to be decoded is a json, this should be improved
    private func decodedData<T: Codable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch let error as NSError {
            print("error decoding json \(error) , \(error.userInfo)")
            return nil
        }
    }
    
    //MARK: - Method to fetch generic data
    //TODO: - This could be improved
    func fetchUserImage(with urlString: String, completion: @escaping (Data?)->Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            completion(data)
        }
        dataTask.resume()
    }
}
