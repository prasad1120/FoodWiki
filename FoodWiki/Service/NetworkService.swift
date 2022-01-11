//
//  NetworkService.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/4/22.
//

import UIKit

/// Singleton class for performing network requests
class NetworkService {
    private init() { }
    static let shared = NetworkService()
    
    private let categoriesUrl: URL! = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
    private let mealsInfo: URL! = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php")
    private let mealDetails: URL! = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php")
    
    
    /// Downloads categories data
    func downloadCategories(_ completion: @escaping (_ categoryAPIResponse: CategoryAPIResponse) -> Void) {
        
        URLSession.shared.dataTask(with: categoriesUrl) { data, response, error in
            
            guard let data = self.checkResponse(data: data, response: response, error: error) else {
                return
            }
            
            do {
                let categoryApiResponse = try JSONDecoder().decode(CategoryAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(categoryApiResponse)
                }
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    /// Downloads meals info data
    func downloadMeals(for categoryName: String, _ completion: @escaping (_ mealsFilterByCategoryAPIResponse: MealsFilterByCategoryAPIResponse) -> Void) {
        
        // Insert category name query param in the url
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "c", value: categoryName)]
        let finalMealsUrl = URL(string: mealsInfo.absoluteString + components.url!.absoluteString)!
        
        URLSession.shared.dataTask(with: finalMealsUrl) { data, response, error in
            
            guard let data = self.checkResponse(data: data, response: response, error: error) else {
                return
            }
            
            do {
                let mealsFilterByCategoryAPIResponse = try JSONDecoder().decode(MealsFilterByCategoryAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(mealsFilterByCategoryAPIResponse)
                }
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    /// Downloads meals details
    func downloadMealDetails(id: String, _ completion: @escaping (_ mealByIDAPIResponse: MealByIDAPIResponse) -> Void) {
        
        // Insert meal id query param in the url
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "i", value: id)]
        let finalMealDetailsUrl = URL(string: mealDetails.absoluteString + components.url!.absoluteString)!
        
        URLSession.shared.dataTask(with: finalMealDetailsUrl) { data, response, error in
            
            guard let data = self.checkResponse(data: data, response: response, error: error) else {
                return
            }
                        
            do {
                let mealByIDAPIResponse = try JSONDecoder().decode(MealByIDAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(mealByIDAPIResponse)
                }
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    
    /// Downloads image from the passed URL
    func downloadImg(index: Int, imgUrl: URL, _ completion: @escaping (_ img: UIImage) -> Void) {
        
        URLSession.shared.dataTask(with: imgUrl) { data, response, error in
            
            guard let data = self.checkResponse(data: data, response: response, error: error) else {
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data)!)
            }
        }.resume()
    }
    
    
    /// Checks for errors and invalid http responses
    func checkResponse(data: Data?, response: URLResponse?, error: Error?) -> Data? {
        if let error = error {
            print(error)
            return nil
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                  
                  print("Error with the response, unexpected status code: \(String(describing: response))")
                  return nil
        }
        
        return data
    }
}

/// Model for categories data API response
struct CategoryAPIResponse: Codable {
    var categories: [Category]
}

/// Model for meals info API response
struct MealsFilterByCategoryAPIResponse: Codable {
    var meals: [MealInfo]
}

/// Model for meals details data API response
struct MealByIDAPIResponse: Decodable {
    var meals: [MealDetails]
}
