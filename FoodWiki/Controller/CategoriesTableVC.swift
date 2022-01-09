//
//  CategoriesTableVC.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/4/22.
//

import UIKit

class CategoriesTableVC: UITableViewController {

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
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.delegate = self
        
        let categoryObj = DataService.shared.getCategoryData(at: indexPath.section) { category in
            DispatchQueue.main.async {
                cell.setCategoryData(categoryData: category)
                tableView.reloadData()
                
            }
        }
        
        if let categoryObj = categoryObj {
            cell.setCategoryData(categoryData: categoryObj)
        } else {
            cell.setCategoryUILoading()
        }
        
        
        let categoryThumb = DataService.shared.getImage(at: indexPath.section, { downloadedImg in
            DispatchQueue.main.async {
                cell.setImage(img: downloadedImg)
            }
        })
        
        if let categoryThumb = categoryThumb {
            cell.setImage(img: categoryThumb)
        } else {
            cell.setImageViewLoading()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowMealsSegue", sender: indexPath)
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
            
            _ = DataService.shared.getImage(at: indexPath.section, { downloadedImg in
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
                }
            })
        }
    }

//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        <#code#>
//    }
}


extension CategoriesTableVC: CategoryCellProtocol {
    func moreInfoTapped(cell: CategoryCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        performSegue(withIdentifier: "ShowCategoryDetailSegue", sender: indexPath)
    }
}
