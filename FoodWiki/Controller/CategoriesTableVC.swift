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
            tableView.reloadData()
        }
        
        if let categoryObj = categoryObj {
            cell.setCategoryData(categoryData: categoryObj)
        } else {
            cell.setCategoryUILoading()
        }
        
        let categoryThumb = DataService.shared.getImage(at: indexPath.section, { _ in
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
        })
        
        if let categoryThumb = categoryThumb {
            cell.setImage(img: categoryThumb)
        } else {
            cell.setImageViewLoading()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "ShowCategoryDetailSegue",
               let categoryDetailsVC = segue.destination as? CategoryDetailsVC {
                
                if let index = sender as? IndexPath {
                    categoryDetailsVC.setData(category: DataService.shared.categories![index.section])
                }
            }
            
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
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            _ = DataService.shared.getImage(at: indexPath.section, { _ in
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
