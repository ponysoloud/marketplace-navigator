//
//  SellerGoodsTableViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 09.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit
/*
class SellerGoodsTableViewController: UITableViewController, ItemStoreDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        (DataSource.user as! SellerUser).items.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (DataSource.user as! SellerUser).items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! SellerItemCell
        let item = (DataSource.user as! SellerUser).items[indexPath.row]
        cell.itemNameLabel.text = item.name
        cell.item = item
        
        return cell
    }
    
    func itemStore(didUpdatedWith index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}*/
