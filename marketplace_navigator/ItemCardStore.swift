//
//  ItemCardStore.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 17.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

class ItemCardStore: GoodResponse {
    
    var cards = [ItemCard]()
    
    private var usedIds = [String]()
    
    subscript(index:Int) -> ItemCard {
        get {
            return cards[index]
        }
        set(new) {
            cards.insert(new, at: index)
        }
    }
    
    var count: Int {
        get {
            return cards.count
        }
    }
    
    override init() {
        
    }
    
    init(json: [String: Any]) {
        for i in json {
            if let temp = i.value as? [String: Any] {
                self.cards.append(ItemCard(json: temp))
            }
        }
    }
    
    func update(json: [String: Any]) {
        for i in json {
            if let temp = i.value as? [String: Any] {
                let item = ItemCard(json: temp)
                if !usedIds.contains(item.itemId) {
                    self.cards.append(item)
                }
            }
        }
    }
    
    func add(item: ItemCard) {
        cards.append(item)
    }
    
    func remove(at: Int) {
        usedIds.append(cards[at].itemId)
        cards.remove(at: at)
    }
    
}
