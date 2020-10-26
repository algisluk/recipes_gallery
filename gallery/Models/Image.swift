//
//  Image.swift
//  gallery
//
//  Created by Algis on 17/10/2020.
//

import Foundation

public struct Image: Decodable {
    
    public let id: String
    public let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "avatar_id"
        case url
    }
}
