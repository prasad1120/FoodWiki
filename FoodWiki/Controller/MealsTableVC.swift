//
//  MealsTableVC.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import UIKit

class MealsTableVC: UITableViewController {
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
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
        } else {
            cell.setImageViewLoading()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let categoryDetailsVC = storyboard.instantiateViewController(identifier: "CategoryDetailsVC") as! CategoryDetailsVC
//
//        self.navigationController?.pushViewController(categoryDetailsVC, animated: true)
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let segueIdentifier = segue.identifier {
//            if segueIdentifier == "ShowCategoryDetailSegue",
//               let categoryDetailsVC = segue.destination as? CategoryDetailsVC {
//
//                if let index = sender as? IndexPath {
//                    categoryDetailsVC.setData(category: DataService.shared.categories![index.section])
//                }
//            }
//        }
//    }
}


extension MealsTableVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {

            _ = DataService.shared.getImage(at: indexPath.section, categoryName: categoryName, { _ in
                self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
            })
        }
    }

//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        <#code#>
//    }
}


//extension MealsTableVC: CategoryCellProtocol {
//    func moreInfoTapped(cell: CategoryCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else {
//            return
//        }
//
//        performSegue(withIdentifier: "ShowCategoryDetailSegue", sender: indexPath)
//    }
//}
