//
//  Model.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/11/1.
//

import UIKit

struct Root: Codable {
    let result: DataResult
}

struct DataResult: Codable {
    let limit: Int
    let offset: Int
    let count: Int
    let sort: String
    let results: [ResultItem]
}

struct ResultItem: Codable {
    let id: Int
    let location: String
    let district: String
    let address: String
    let longitude: String
    let latitude: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case location
        case district
        case address
        case longitude
        case latitude
    }
        
}

