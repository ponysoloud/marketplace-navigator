//
//  CustomStorage.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 13.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import UIKit

class CustomStorage<T: Comparable> {
    
    var items = [T]()
    
    weak var delegate: CustomStorageDelegate?
    
    subscript(index:Int) -> T {
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
    
    init() { }
    
    func add(item: T) {
        items.append(item)
        delegate?.customStorage(didUpdatedIn: count - 1)
    }
    
    func contains(item: Comparable) -> Bool {
        let cardsContains = items.contains(where: { $0.id == item.id })
        return cardsContains
    }
    
    func get(with itemId: String) -> T? {
        guard let indx = items.index(where: { $0.id == itemId }) else {
            return nil
        }
        
        return items[indx]
    }
    
    func remove(at index: Int) {
        if index < count {
            items.remove(at: index)
        }
    }
}

extension CustomStorage where T: Jsonable {
    
    convenience init(json: [String: Any]) {
        self.init()
        
        for i in json {
            if let temp = i.value as? [String: Any] {
                var item = T(json: temp)
                    item.id = i.key
                items.append(item)
            }
        }
    }
    
}
