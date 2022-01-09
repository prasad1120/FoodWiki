//
//  NetworkService.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/4/22.
//

import UIKit

class NetworkService {
    private init() { }
    static let shared = NetworkService()
    
    
    private let categoriesUrl: URL! = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
    private let mealsUrl: URL! = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php")
    
    
    func downloadCategories(_ completion: @escaping (_ categoryAPIResponse: CategoryAPIResponse) -> Void) {
        
        URLSession.shared.dataTask(with: categoriesUrl) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      
                      print("Error with the response, unexpected status code: \(String(describing: response))")
                      return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let categoryApiResponse = try JSONDecoder().decode(CategoryAPIResponse.self, from: data)
                completion(categoryApiResponse)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    
    func downloadMeals(for categoryName: String, _ completion: @escaping (_ mealsFilterByCategoryAPIResponse: MealsFilterByCategoryAPIResponse) -> Void) {
        
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "c", value: categoryName)]
        let finalMealsUrl = URL(string: mealsUrl.absoluteString + components.url!.absoluteString)!
        
        URLSession.shared.dataTask(with: finalMealsUrl) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      
                      print("Error with the response, unexpected status code: \(String(describing: response))")
                      return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let mealsFilterByCategoryAPIResponse = try JSONDecoder().decode(MealsFilterByCategoryAPIResponse.self, from: data)
                completion(mealsFilterByCategoryAPIResponse)
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    
    
    func downloadImg(index: Int, imgUrl: URL, _ completion: @escaping (_ img: UIImage) -> Void) {
        
        URLSession.shared.dataTask(with: imgUrl) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      
                      print("Error with the response, unexpected status code: \(String(describing: response))")
                      return
            }
            
            guard let data = data else {
                return
            }
            
            completion(UIImage(data: data)!)
        }.resume()
    }
}


struct CategoryAPIResponse: Codable {
    var categories: [Category]
}

struct MealsFilterByCategoryAPIResponse: Codable {
    var meals: [MealInfo]
}
