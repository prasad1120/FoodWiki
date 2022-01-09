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
    
    func getImage(at index: Int, _ completion: ((_ img: UIImage) -> Void)?) -> UIImage? {
        
        guard let imgData = categories?[index].imageData else {
            
            if let url = categories?[index].strCategoryThumb {
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
                self.categories = categoryAPIResponse.categories.sorted(by: { $0.strCategory < $1.strCategory })
                completion(self.categories![index])
            }
            
            return nil
        }
        
        return categories?[index]
    }
}
