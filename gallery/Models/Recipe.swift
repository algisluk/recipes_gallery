//
//  Recipe.swift
//  gallery
//
//  Created by Algis on 26/10/2020.
//

import Foundation

struct RecipeResponse: Decodable {
    
    public let title: String
    public let all: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case title
        case all = "results"
    }
}


struct Recipe: Decodable {
    
    public let title: String
    public let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
    }
}
