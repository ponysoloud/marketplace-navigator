//
//  SellerItemCell.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 12.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class SellerItemCell: UITableViewCell {
    
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var itemImageView: UIImageView!
    
    var item: Item!
    
}
