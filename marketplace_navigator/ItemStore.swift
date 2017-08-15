//
//  ItemStore.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 09.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class ItemStore {
    
    var items = [Item]()
    
    weak var delegate: ItemStoreDelegate?
    
    subscript(index:Int) -> Item {
        get {
            return items[index]
        }
        set(new) {
            items.insert(new, at: index)
        }
    }
    
    var count: Int {
        get {
            return items.count
        }
    }
    
    init() {

    }
    
    init(json: [String: Any]) {
        for i in json {
            if let temp = i.value as? [String: Any] {
                self.items.append(Item(json: temp))
            }
        }
    }
    
    func add(item: Item) {
        items.append(item)
        delegate?.itemStore(self, didUpdatedWith: count - 1)
    }
    
    
}
