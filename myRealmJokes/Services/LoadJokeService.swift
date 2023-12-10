//
//  LoadJokeService.swift
//  myRealmJokes
//
//  Created by Никита on 09.12.2023.
//

import Foundation

class LoadJokeService {
    
    let urlString = "https://api.chucknorris.io/jokes/random"
    
    static func loadJson(completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: LoadJokeService().urlString) {
                let urlSession = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                    }
                    if let data = data {
                        completion(.success(data))
                    }
                }
                urlSession.resume()
            }
        }
            
        static func parse<T:Decodable>(jsonData: Data, model: T.Type) -> T? {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                print("Data Decoded!")
                return decodedData
            } catch {
                print("decode error")
                return nil
            }
        }
    
}
