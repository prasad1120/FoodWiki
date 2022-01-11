//
//  MealDetails.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import Foundation


class MealDetails: Decodable {
    var id: String
    var name: String
    var drinkAlternate: String?
    var category: String
    var area: String?
    var instructions: String
    var imgUrl: URL
    var tags: [String]?
    var ytUrl: URL?
    var ingredients = [Ingredient]()
    var source: URL?
    var imgSource: String?
    var creativeCommonsConfirmed: String?
    var dateModified: String?
    
    class Ingredient {
        var name: String
        var measure: String

        init(name: String, measure: String) {
            self.name = name
            self.measure = measure
        }
    }
    
    /// Struct to help with creating dynamic keys for decoding
    private struct CodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: CodingKeys(stringValue: "idMeal")!)
        name = try values.decode(String.self, forKey: CodingKeys(stringValue: "strMeal")!)
        
        drinkAlternate = MealDetails.getNonEmptyValue(container: values, key: "strDrinkAlternate")
        category = try values.decode(String.self, forKey: CodingKeys(stringValue: "strCategory")!)
        area = try values.decode(String.self, forKey: CodingKeys(stringValue: "strArea")!)
        instructions = (try values.decode(String.self, forKey: CodingKeys(stringValue: "strInstructions")!))
        imgUrl = URL(string: try! values.decode(String.self, forKey: CodingKeys(stringValue: "strMealThumb")!))!
        
        // Get array of Strings from comma separated tags
        if let tagsValue = try? values.decode(String.self, forKey: CodingKeys(stringValue: "strTags")!) {
            tags = tagsValue.components(separatedBy: ",")
            tags = tags?.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        }
        
        if let ytUrlStr = MealDetails.getNonEmptyValue(container: values, key: "strYoutube"),
           let ytUrlValue = URL(string: ytUrlStr) {
            ytUrl = ytUrlValue
        }
        
        // Get Ingredient objects from ingredients and measures
        for i in 1...20 {
            if let ingredientName = MealDetails.getNonEmptyValue(container: values, key: "strIngredient\(i)"),
               let measure = MealDetails.getNonEmptyValue(container: values, key: "strMeasure\(i)") {
                ingredients.append(Ingredient(name: ingredientName, measure: measure))
            } else {
                break
            }
        }
        
        if let sourcelUrlStr = MealDetails.getNonEmptyValue(container: values, key: "strSource"),
           let sourceValue = URL(string: sourcelUrlStr) {
            source = sourceValue
        }
        
        imgSource = MealDetails.getNonEmptyValue(container: values, key: "strImageSource")
        creativeCommonsConfirmed = MealDetails.getNonEmptyValue(container: values, key: "strCreativeCommonsConfirmed")
        dateModified = MealDetails.getNonEmptyValue(container: values, key: "dateModified")
    }
    
    /// Get non empty value after checking for whitespaces or newlines
    private static func getNonEmptyValue(container: KeyedDecodingContainer<MealDetails.CodingKeys>, key: String) -> String? {
        
        guard let value = (try? container.decode(String.self, forKey: CodingKeys(stringValue: key)!))?.trimmingCharacters(in: .whitespacesAndNewlines),
           value.isEmpty == false else {
            return nil
        }
        return value
    }
}
