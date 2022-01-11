//
//  GenericFoodListTableVC.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/10/22.
//

import UIKit

class GenericFoodListTableVC: UITableViewController {
    
    var onCellClickSegueId: String! {
        return nil
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: onCellClickSegueId, sender: indexPath)
    }
}
