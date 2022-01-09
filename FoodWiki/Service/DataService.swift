//
//  DataService.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/5/22.
//

import Foundation
import UIKit


class DataService {
    private init() { }
    static let shared = DataService()
    
    var categories: [Category]?
    var mealsInfo: [String: [MealInfo]] = [:]
    
    func getImage(at index: Int, _ completion: ((_ img: UIImage) -> Void)?) -> UIImage? {
        
        guard let imgData = categories?[index].imageData else {
            
            if let url = categories?[index].imgUrl {
                NetworkService.shared.downloadImg(index: index, imgUrl: url) { downloadedImg in
                    self.categories?[index].imageData = downloadedImg
                    completion?(downloadedImg)
                }
            }
            
            return nil
        }
        
        return imgData
    }
    
    func getCategoryData(at index: Int, _ completion: @escaping (_ category: Category) -> Void) -> Category? {
        
        guard let _ = categories else {
            NetworkService.shared.downloadCategories { categoryAPIResponse in
                self.categories = categoryAPIResponse.categories.sorted(by: { $0.name < $1.name })
                completion(self.categories![index])
            }
            
            return nil
        }
        
        return categories?[index]
    }
    
    
    func getMealInfoData(at index: Int, categoryName: String, _ completion: @escaping (_ mealInfo: MealInfo) -> Void) -> MealInfo? {
        
        guard let _ = mealsInfo[categoryName] else {
            
            NetworkService.shared.downloadMeals(for: categoryName) { mealsFilterByCategoryAPIResponse in
                self.mealsInfo[categoryName] = mealsFilterByCategoryAPIResponse.meals.sorted(by: { $0.name < $1.name })
                completion(self.mealsInfo[categoryName]![index])
            }
            
            return nil
        }
        
        return mealsInfo[categoryName]![index]
    }
}
