//
//  NetworkService.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/4/22.
//

import Foundation

class NetworkService {
    private init() { }
    static let shared = NetworkService()
    
}


struct CategoryResponse: Codable {
    var categories: [Category]
}
