//
//  Category.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/4/22.
//

import Foundation
import UIKit

struct Category: Codable {
    var id: String
    var name: String
    var imgUrl: URL
    var description: String
    /// UIImage at the URL specified by imgUrl
    var imageData: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case imgUrl = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        imgUrl = URL(string: try! values.decode(String.self, forKey: .imgUrl))!
        description = try values.decode(String.self, forKey: .description)
    }
}
