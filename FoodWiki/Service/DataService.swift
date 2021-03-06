//
//  DataService.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/5/22.
//

import Foundation
import UIKit

/// Singleton class for managing data
class DataService {
    private init() { }
    static let shared = DataService()
    
    var isCategoriesAPICalled = false
    
    // Dictionaries to avoid making the same request calls again
    var isCategoriesImgAPICalled: [Int: Bool] = [:]
    var isMealInfoAPICalled: [String: Bool] = [:]
    var isMealInfoImgAPICalled: [String: [Int: Bool]] = [:]
    var isMealDetailsAPICalled: [String: Bool] = [:]
    
    var categories: [Category]?
    var mealsInfo: [String: [MealInfo]] = [:]
    var mealDetails: [String: MealDetails] = [:]
    
    
    /// Returns saved category img if available, otherwise downloads it from NetworkService
    func getCategoryImage(at index: Int, _ completion: ((_ img: UIImage) -> Void)?) -> UIImage? {
        
        guard let imgData = categories?[index].imageData else {
            
            if let url = categories?[index].imgUrl,
                isCategoriesImgAPICalled[index] != true {
                
                NetworkService.shared.downloadImg(index: index, imgUrl: url) { downloadedImg in
                    self.categories?[index].imageData = downloadedImg
                    completion?(downloadedImg)
                }
                isCategoriesImgAPICalled[index] = true
            }
            
            return nil
        }
        
        return imgData
    }
    
    
    /// Returns saved meal img if available, otherwise downloads it from NetworkService
    func getMealImage(at index: Int, categoryName: String, _ completion: ((_ img: UIImage) -> Void)?) -> UIImage? {
        
        guard let imgData = mealsInfo[categoryName]?[index].imageData else {
            
            if let url = mealsInfo[categoryName]?[index].imgUrl,
                isMealInfoImgAPICalled[categoryName]?[index] != true {
                
                if isMealInfoImgAPICalled[categoryName] == nil {
                    isMealInfoImgAPICalled[categoryName] = [:]
                }
                
                isMealInfoImgAPICalled[categoryName]![index] = true
                
                NetworkService.shared.downloadImg(index: index, imgUrl: url) { downloadedImg in
                    self.mealsInfo[categoryName]?[index].imageData = downloadedImg
                    completion?(downloadedImg)
                }
            }
            
            return nil
        }
        
        return imgData
    }
    
    
    /// Returns saved category data if available, otherwise downloads it from NetworkService
    func getCategoryData(at index: Int, _ completion: @escaping (_ category: Category) -> Void) -> Category? {
        
        guard let _ = categories else {
            
            if isCategoriesAPICalled == false {
                NetworkService.shared.downloadCategories { categoryAPIResponse in
                    self.categories = categoryAPIResponse.categories.sorted(by: { $0.name < $1.name })
                    completion(self.categories![index])
                }
                isCategoriesAPICalled = true
            }
            
            return nil
        }
        
        return categories?[index]
    }
    
    
    /// Returns saved meal info data if available, otherwise downloads it from NetworkService
    func getMealInfoData(at index: Int, categoryName: String, _ completion: ((_ mealInfo: MealInfo) -> Void)?) -> MealInfo? {
        
        guard let _ = mealsInfo[categoryName] else {
            
            if isMealInfoAPICalled[categoryName] != true {
                
                NetworkService.shared.downloadMeals(for: categoryName) { mealsFilterByCategoryAPIResponse in
                    self.mealsInfo[categoryName] = mealsFilterByCategoryAPIResponse.meals.sorted(by: { $0.name < $1.name })
                    completion?(self.mealsInfo[categoryName]![index])
                }
                
                isMealInfoAPICalled[categoryName] = true
            }
            
            return nil
        }
        
        return mealsInfo[categoryName]![index]
    }
    
    
    /// Returns saved meal details data if available, otherwise downloads it from NetworkService
    func getMealDetails(id: String, _ completion: @escaping (_ mealDetails: MealDetails) -> Void) -> MealDetails? {
        
        guard let _ = mealDetails[id] else {
            if isMealDetailsAPICalled[id] != true {
                
                NetworkService.shared.downloadMealDetails(id: id) { mealByIDAPIResponse in
                    self.mealDetails[id] = mealByIDAPIResponse.meals.first
                    completion(self.mealDetails[id]!)
                }
                
                isMealDetailsAPICalled[id] = true
            }
            
            return nil
        }
        
        return mealDetails[id]
    }
}
