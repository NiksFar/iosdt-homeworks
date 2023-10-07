//
//  NetworkService.swift
//  Navigation
//
//  Created by Никита on 07.10.2023.
//

import Foundation

struct NetworkService {
    
    static func request(for configuration: AppConfiguration) {
        let stringURL = configuration.rawValue
        let url = URL(string: stringURL)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, responce, error in
            print ("data", data as Any)
            //print ("responce", responce)
            if let httpResponse = responce as? HTTPURLResponse {
                print("statusCode \(httpResponse.statusCode)")
                print("allHeaderFields \(httpResponse.allHeaderFields)")
            }
            if let error = error {
                print ("error", error.localizedDescription)
            }
        }.resume()
    }
}

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people/8"
    case starships = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"
}
