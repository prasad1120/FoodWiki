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
        if let mealsInfo = DataService.shared.mealsInfo[categoryName] {
            return mealsInfo.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealCell
        
        let mealInfoObj = DataService.shared.getMealInfoData(at: indexPath.section, categoryName: categoryName) { mealInfo in
            tableView.reloadData()
        }
        
        if let mealInfoObj = mealInfoObj {
            cell.setMealInfo(mealInfo: mealInfoObj)
        } else {
            cell.setCategoryUILoading()
        }
        
        
        let mealThumb = DataService.shared.getImage(at: indexPath.section, categoryName: categoryName, { _ in
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
        })

        if let mealThumb = mealThumb {
            cell.setImage(img: mealThumb)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
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
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {

            _ = DataService.shared.getImage(at: indexPath.section, categoryName: categoryName, { _ in
                self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
            })
        }
    }
}

