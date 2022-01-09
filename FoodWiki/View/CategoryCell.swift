//
//  CategoryCell.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/6/22.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var thumbImgView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryDescription: UILabel!
    
    let animationTime = 0.25
    
    func setImageViewLoading() {
        thumbImgView.backgroundColor = UIColor.systemFill
    }
    
    func setImage(img: UIImage) {
        let temp = UIImage.scale(img: img, scale: 1.5)
        UIView.animate(withDuration: animationTime) {
            
            self.thumbImgView.backgroundColor = UIColor.systemFill
        }
        UIView.transition(with: thumbImgView,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.thumbImgView.image = temp },
                          completion: nil)
    }
    
    func setCategoryData(categoryData: Category) {
        setImageViewLoading()
        UIView.animate(withDuration: animationTime) {
            
            self.categoryName.layer.backgroundColor = UIColor.clear.cgColor
            self.categoryDescription.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        UIView.transition(with: categoryName,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.categoryName.text = categoryData.strCategory },
                          completion: nil)
        
        UIView.transition(with: categoryDescription,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.categoryDescription.text = categoryData.strCategoryDescription},
                          completion: nil)
    }
    
    func setCategoryUILoading() {
        categoryName.layer.backgroundColor = UIColor.systemGray5.cgColor
        categoryDescription.layer.backgroundColor = UIColor.systemGray5.cgColor
        
        categoryName.text = ""
        categoryDescription.text = ""
        
        setImageViewLoading()
    }
}

