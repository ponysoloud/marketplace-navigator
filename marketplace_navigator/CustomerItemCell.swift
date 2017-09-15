//
//  CustomerItemCell.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 25.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class CustomerItemCell: UITableViewCell {
    
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var brandNameLabel: UILabel!
    
    var item: Item!
    
    func setValues(card: ItemCard) {
        self.item = card.item
        itemImageView.downloadedFrom(link: item.image)
        itemNameLabel.text = item.name
        brandNameLabel.text = card.hostName
    }
    
}
