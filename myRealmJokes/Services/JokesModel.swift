//
//  JokesModel.swift
//  myRealmJokes
//
//  Created by Никита on 09.12.2023.
//

import Foundation

struct Jokes: Codable {
    let categories: [String]
    let createdAt: String
    let iconURL: String
    let id: String
    let updatedAt: String
    let url: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url
        case value
    }
    
}


