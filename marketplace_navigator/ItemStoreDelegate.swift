//
//  ItemStoreDelegate.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 11.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

protocol ItemStoreDelegate: NSObjectProtocol {
    
    func itemStore(_ store: ItemStore, didUpdatedWith index: Int)
    
}
