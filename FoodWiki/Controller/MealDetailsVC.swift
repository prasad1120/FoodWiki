//
//  MealDetailsVC.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import UIKit
import WebKit

class MealDetailsVC: UIViewController {
    
    @IBOutlet weak var ingredientsTVHeight: NSLayoutConstraint!
    @IBOutlet var ytPlayer: WKWebView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var areaLbl: UILabel!
    @IBOutlet var tagsLbl: TagsLbl!
    @IBOutlet var ingredientsTableView: UITableView! {
        didSet {
            ingredientsTableView.dataSource = self
        }
    }
    @IBOutlet weak var instructionsLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var linkImgView: UIImageView! {
        didSet {
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(linkImgViewTapped))
            linkImgView.isUserInteractionEnabled = true
            linkImgView.addGestureRecognizer(singleTap)
        }
    }
    
    var id: String!
    var indexInTable: Int!
    var categoryName: String!
    
    var mealDetails: MealDetails? {
        didSet {
            setUI()
        }
    }
    
    func setData(id: String, indexInTable: Int, categoryName: String) {
        self.id = id
        self.indexInTable = indexInTable
        self.categoryName = categoryName
    }
    
    override func viewDidLoad() {
        
        // Get mealDetails
        let mealDetailsObj = DataService.shared.getMealDetails(id: id) { mealDetails in
            
            self.mealDetails = mealDetails
        }
        
        if let mealDetailsObj = mealDetailsObj {
            self.mealDetails = mealDetailsObj
        }
    }
    
    func setUI() {
        
        // Convert regular YT to link to embed link
        if let ytUrl = mealDetails?.ytUrl,
           let ytId = ytUrl.valueOf("v"),
           let ytUrl = URL(string: "https://www.youtube.com/embed/\(ytId)?playsinline=1") {
            
            ytPlayer.load(URLRequest(url: ytUrl))
        } else {
            
            // If link is not available, hide YT player and show meal thumb image instead
            ytPlayer.isHidden = true
            imgView.isHidden = false
            imgView.image = DataService.shared.getMealInfoData(at: indexInTable, categoryName: categoryName, nil)?.imageData
        }
        
        nameLbl.text = mealDetails?.name
        areaLbl.text = mealDetails?.area
        
        // Convert array of tags to a single space separated string
        var tagsString = ""
        mealDetails?.tags?.forEach({ tag in
            tagsString.append(tag + " ")
        })
        
        tagsLbl.setAttributedString(textContent: tagsString)
        
        // Reload ingredients table view since data is available
        ingredientsTableView.reloadData()
        // Set new content height of table view to its height constraint to prevent scrolling
        ingredientsTVHeight.constant = ingredientsTableView.contentSize.height
        
        instructionsLbl.text = mealDetails?.instructions
        
        // Show link icon if source url is available
        if let _ = mealDetails?.source {
            linkImgView.isHidden = false
        }
    }
    
    @objc func linkImgViewTapped() {
        if let url = mealDetails?.source {
            // Open source url in Safari
            UIApplication.shared.open(url)
        }
    }
}


extension MealDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let noOfRows = mealDetails?.ingredients.count {
            return noOfRows
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        cell.textLabel?.text = mealDetails?.ingredients[indexPath.row].name
        cell.detailTextLabel?.text = mealDetails?.ingredients[indexPath.row].measure
        
        return cell
    }
}
