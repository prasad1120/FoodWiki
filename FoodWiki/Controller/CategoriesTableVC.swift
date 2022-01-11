//
//  CategoriesTableVC.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/4/22.
//

import UIKit

class CategoriesTableVC: GenericFoodListTableVC {
    
    override var onCellClickSegueId: String! {
        return "ShowMealsSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Set no. of sections equal to no. of categories downloaded, otherwise set 1
        if let categories = DataService.shared.categories {
            return categories.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.delegate = self
        
        let categoryObj = DataService.shared.getCategoryData(at: indexPath.section) { category in
            // Reload table on downloading categories data
            tableView.reloadData()
        }
        
        // If category Data available then set it to UI otherwise set loading view
        if let categoryObj = categoryObj {
            cell.setCategoryData(categoryData: categoryObj)
        } else {
            cell.setCategoryUILoading()
        }
        
        let categoryThumb = DataService.shared.getCategoryImage(at: indexPath.section, { _ in
            // Reload specific section on downloading category thumb img
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
        })
        
        // Set category thumb image if available
        if let categoryThumb = categoryThumb {
            cell.setImage(img: categoryThumb)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            
            // Segue to show Category details VC
            if segueIdentifier == "ShowCategoryDetailSegue",
               let categoryDetailsVC = segue.destination as? CategoryDetailsVC {
                
                if let index = sender as? IndexPath {
                    categoryDetailsVC.setData(category: DataService.shared.categories![index.section])
                }
            }
            
            // Segue to show Meals table VC
            if segueIdentifier == "ShowMealsSegue",
               let mealsTableVC = segue.destination as? MealsTableVC {
                
                if let index = sender as? IndexPath {
                    mealsTableVC.setData(categoryName: DataService.shared.categories![index.section].name)
                }
            }
        }
    }
}


extension CategoriesTableVC: UITableViewDataSourcePrefetching {
    
    // Download category thumb images on demand basis
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            _ = DataService.shared.getCategoryImage(at: indexPath.section, { _ in
                // Reload specific section on downloading category thumb img
                self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
            })
        }
    }
}


extension CategoriesTableVC: CategoryCellProtocol {
    func moreInfoTapped(cell: CategoryCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        performSegue(withIdentifier: "ShowCategoryDetailSegue", sender: indexPath)
    }
}
