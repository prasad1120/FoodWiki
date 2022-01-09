//
//  CategoryDetailsVC.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/8/22.
//

import UIKit

class CategoryDetailsVC: UIViewController {
    
    @IBOutlet weak var categoryImgView: UIImageView! {
        didSet {
            categoryImgView.image = category.imageData!
        }
    }
    
    @IBOutlet weak var categoryNameLbl: UILabel! {
        didSet {
            categoryNameLbl.text = category.strCategory
        }
    }
    
    @IBOutlet weak var categoryDescriptionLbl: UILabel! {
        didSet {
            categoryDescriptionLbl.text = category.strCategoryDescription
        }
    }
    
    var category: Category!
    
    func setData(category: Category) {
        self.category = category
    }
}
