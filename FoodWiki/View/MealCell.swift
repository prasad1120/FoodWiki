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
    
    func setCategoryUILoading() {
        nameLbl.layer.backgroundColor = UIColor.systemGray5.cgColor
        nameLbl.text = ""
    }
}
