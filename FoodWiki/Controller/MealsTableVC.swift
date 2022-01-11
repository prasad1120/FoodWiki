//
//  MealsTableVC.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import UIKit

class MealsTableVC: GenericFoodListTableVC {
    
    override var onCellClickSegueId: String! {
        return "ShowMealDetail"
    }
    
    var categoryName: String! {
        didSet {
            title = categoryName
        }
    }
    
    func setData(categoryName: String) {
        self.categoryName = categoryName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Set no. of sections equal to no. of mealsInfo downloaded, otherwise set 1
        if let mealsInfo = DataService.shared.mealsInfo[categoryName] {
            return mealsInfo.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealCell
        
        let mealInfoObj = DataService.shared.getMealInfoData(at: indexPath.section, categoryName: categoryName) { mealInfo in
            // Reload table on downloading mealsInfo data
            tableView.reloadData()
        }
        
        // If mealsInfo Data available then set it to UI otherwise set loading view
        if let mealInfoObj = mealInfoObj {
            cell.setMealInfo(mealInfo: mealInfoObj)
        } else {
            cell.setCategoryUILoading()
        }
        
        
        let mealThumb = DataService.shared.getMealImage(at: indexPath.section, categoryName: categoryName, { _ in
            // Reload specific section on downloading meal thumb img
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
        })

        // Set meal thumb image if available
        if let mealThumb = mealThumb {
            cell.setImage(img: mealThumb)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            
            // Segue to show Meal details VC
            if segueIdentifier == "ShowMealDetail",
               let mealDetailsVC = segue.destination as? MealDetailsVC {

                if let index = sender as? IndexPath {
                    mealDetailsVC.setData(id: DataService.shared.mealsInfo[categoryName]![index.section].id, indexInTable: index.section, categoryName: categoryName)
                }
            }
        }
    }
}


extension MealsTableVC: UITableViewDataSourcePrefetching {
    
    // Download mealInfo thumb images on demand basis
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {

            _ = DataService.shared.getMealImage(at: indexPath.section, categoryName: categoryName, { _ in
                self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
            })
        }
    }
}

