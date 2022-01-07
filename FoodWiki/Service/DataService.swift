//
//  DataService.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/5/22.
//

import Foundation


class DataService {
    private init() { }
    static let shared = DataService()
    
    var categories: [Category]?
}
