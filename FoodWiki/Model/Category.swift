//
//  Category.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/4/22.
//

import Foundation
import UIKit

struct Category: Codable {
    var idCategory: String
    var strCategory: String
    var strCategoryThumb: URL
    var strCategoryDescription: String
    var imageData: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case idCategory, strCategory, strCategoryThumb, strCategoryDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idCategory = try values.decode(String.self, forKey: .idCategory)
        strCategory = try values.decode(String.self, forKey: .strCategory)
        strCategoryThumb = URL(string: try! values.decode(String.self, forKey: .strCategoryThumb))!
        strCategoryDescription = try values.decode(String.self, forKey: .strCategoryDescription)
    }
}
