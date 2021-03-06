//
//  CategoryCell.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/6/22.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var thumbImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var moreInfoImgView: UIImageView! {
        didSet {
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(moreInfoTapDetected))
            moreInfoImgView.isUserInteractionEnabled = true
            moreInfoImgView.addGestureRecognizer(singleTap)
        }
    }
    
    let animationTime = 0.25
    var delegate: CategoryCellProtocol?
    
    @objc func moreInfoTapDetected() {
        delegate?.moreInfoTapped(cell: self)
    }
    
    /// Sets image to the thumbImgView with animation
    func setImage(img: UIImage) {
        UIView.animate(withDuration: animationTime) {
            
            self.thumbImgView.backgroundColor = UIColor.systemFill
        }
        
        UIView.transition(with: thumbImgView,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.thumbImgView.image = UIImage.scale(img: img, scale: 1.5) },
                          completion: nil)
    }
    
    /// Sets category data to the CategoryCell UI with animation
    func setCategoryData(categoryData: Category) {
        UIView.animate(withDuration: animationTime) {
            
            self.moreInfoImgView.isHidden = false
            self.nameLbl.layer.backgroundColor = UIColor.clear.cgColor
            self.descriptionLbl.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        UIView.transition(with: nameLbl,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.nameLbl.text = categoryData.name },
                          completion: nil)
        
        UIView.transition(with: descriptionLbl,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.descriptionLbl.text = categoryData.description},
                          completion: nil)
    }
    
    /// Shows loading effect on the cell
    func setCategoryUILoading() {
        nameLbl.layer.backgroundColor = UIColor.systemGray5.cgColor
        descriptionLbl.layer.backgroundColor = UIColor.systemGray5.cgColor
        
        nameLbl.text = ""
        descriptionLbl.text = ""
        moreInfoImgView.isHidden = true
        
    }
}

/// Facilitates communication from CategoryCell to CategoriesTableVC
protocol CategoryCellProtocol {
    func moreInfoTapped(cell: CategoryCell)
}

