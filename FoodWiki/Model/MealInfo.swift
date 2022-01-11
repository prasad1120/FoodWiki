//
//  MealInfo.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import UIKit

struct MealInfo: Codable {
    var id: String
    var name: String
    var imgUrl: URL
    /// UIImage at the URL specified by imgUrl
    var imageData: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imgUrl = "strMealThumb"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        imgUrl = URL(string: try! values.decode(String.self, forKey: .imgUrl))!
    }
}
