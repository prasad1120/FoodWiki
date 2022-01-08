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
        thumbImgView.backgroundColor = #colorLiteral(red: 0.6225500107, green: 0.6225500107, blue: 0.6225500107, alpha: 1)
    }
    
    func setImage(img: UIImage) {
        let temp = UIImage.scale(img: img, scale: 1.5)
        UIView.animate(withDuration: animationTime) {
            
            self.thumbImgView.backgroundColor = UIColor.clear
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
        categoryName.layer.backgroundColor = #colorLiteral(red: 0.9000000358, green: 0.9000000358, blue: 0.9000000358, alpha: 1).cgColor
        categoryDescription.layer.backgroundColor = #colorLiteral(red: 0.9000000358, green: 0.9000000358, blue: 0.9000000358, alpha: 1).cgColor
        
        categoryName.text = ""
        categoryDescription.text = ""
        
        setImageViewLoading()
    }
}


extension UIImage {
    static func scale(img: UIImage, scale: CGFloat) -> UIImage {
        
        let newSize = CGSize(width: img.size.width * scale, height: img.size.height * scale)

        UIGraphicsBeginImageContext(newSize)
        img.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
