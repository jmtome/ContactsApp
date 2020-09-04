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
    //MARK: - Accessable Singleton
    static let shared = NetworkManager()
    
    //Eventually this class could be made more generic and a session could be passed, but for now it will be a private property and it will use the shared session
    private let session = URLSession.shared
    
    //MARK: - Generic Network Request
    // This makes a request with a urlString and has a completion closure with a Result of type Data or a NetworkError
    func genericRequest(with urlString: String, completion: @escaping (Result<Data,NetworkError>)-> Void ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.clientNetworkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverNetworkError))
                print(urlString)
                return
            }
            guard let data = data else {
                completion(.failure(.nilDataError))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}

extension NetworkManager {
    //MARK: - JSON Fetch Request
    // this method makes a generic request that it then de-serializes into the JSON type T passed by the caller in the completion closure (in success) or a networkError (in failure)
    func JSONFetchRequest<T: Codable>(with urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        genericRequest(with: urlString) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let data):
                self.decodeData(data) { (res: Result<T, NetworkError>) in
                    switch res {
                    case .success(let decodedData):
                        completion(.success(decodedData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension NetworkManager {
    //MARK: - DecodeData
    // this method de-serializes a data chunk into a JSON-created type T, which is to be Codable
    private func decodeData<T: Codable>(_ data: Data, completion: @escaping (Result<T,NetworkError>)-> Void ) {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(T.self, from: data)
            completion(.success(decoded))
        } catch {
            completion(.failure(NetworkError.dataDecodingError))
        }
    }
}
