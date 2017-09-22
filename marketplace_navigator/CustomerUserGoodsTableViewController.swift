//
//  CustomerUserGoodsTableViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 25.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class CustomerUserGoodsTableViewController: UITableViewController, CustomStorageDelegate {
    
    var selectedCellViewController: CustomerDetailInfoViewController?
    
    @IBOutlet var emptyTableNotifyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.tableFooterView = UIView(frame: .zero)
        
        (DataSource.user as! CustomerUser).likedItems.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (DataSource.user as! CustomerUser).likedItems.count
        if count == 0 { tableView.backgroundView = emptyTableNotifyView }
        else { tableView.backgroundView = nil }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = (DataSource.user as! CustomerUser).likedItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedItemCell", for: indexPath) as! CustomerItemCell
        
        cell.setValues(card: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = (DataSource.user as! CustomerUser).likedItems[indexPath.row]
        selectedCellViewController?.setValues(with: item)
        selectedCellViewController?.itemIndexPathOnTableView = indexPath
    }
    
    func removeItem(at indexPath: IndexPath) {
        (DataSource.user as! CustomerUser).likedItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func customStorage(didUpdatedIn index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Embed Segue" {
            let destinationVC = segue.destination as! CustomerDetailInfoViewController
            destinationVC.parentTableViewController = self
            self.selectedCellViewController = destinationVC
        }
    }
    
}
