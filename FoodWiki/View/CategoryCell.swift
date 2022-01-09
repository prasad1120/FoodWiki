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
    @IBOutlet weak var moreInfoImgView: UIImageView!
    
    let animationTime = 0.25
    var delegate: CategoryCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(moreInfoTapDetected))
        moreInfoImgView.isUserInteractionEnabled = true
        moreInfoImgView.addGestureRecognizer(singleTap)
    }
    
    @objc func moreInfoTapDetected() {
        delegate?.moreInfoTapped(cell: self)
    }
    
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
            
            self.moreInfoImgView.isHidden = false
            self.categoryName.layer.backgroundColor = UIColor.clear.cgColor
            self.categoryDescription.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        UIView.transition(with: categoryName,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.categoryName.text = categoryData.name },
                          completion: nil)
        
        UIView.transition(with: categoryDescription,
                          duration: animationTime,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.categoryDescription.text = categoryData.description},
                          completion: nil)
    }
    
    func setCategoryUILoading() {
        categoryName.layer.backgroundColor = UIColor.systemGray5.cgColor
        categoryDescription.layer.backgroundColor = UIColor.systemGray5.cgColor
        
        categoryName.text = ""
        categoryDescription.text = ""
        moreInfoImgView.isHidden = true
        
        setImageViewLoading()
    }
}


protocol CategoryCellProtocol {
    func moreInfoTapped(cell: CategoryCell)
}

