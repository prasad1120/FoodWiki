//
//  MealCell.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import UIKit

class MealCell: UITableViewCell {
    
    @IBOutlet weak var thumbImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    let animationTime = 0.25
    
    /// Sets image to the thumbImgView with animation
    func setImage(img: UIImage) {
        UIView.animate(withDuration: animationTime) {
            
            self.thumbImgView.backgroundColor = UIColor.systemFill
        }
        UIView.transition(with: thumbImgView,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.thumbImgView.image = UIImage.scale(img: img, scale: 1) },
                          completion: nil)
    }
    
    /// Sets mealInfo data to the MealCell UI with animation
    func setMealInfo(mealInfo: MealInfo) {
        UIView.animate(withDuration: animationTime) {
            
            self.nameLbl.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        UIView.transition(with: nameLbl,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.nameLbl.text = mealInfo.name },
                          completion: nil)
    }
    
    /// Shows loading effect on the cell
    func setCategoryUILoading() {
        nameLbl.layer.backgroundColor = UIColor.systemGray5.cgColor
        nameLbl.text = ""
    }
}
