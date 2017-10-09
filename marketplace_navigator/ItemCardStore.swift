//
//  ItemCardStore.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 17.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import Koloda

class ItemCardStore: GoodResponse {
    
    var cards = [ItemCard]()
    
    private var buffer = [ItemCard]()
    
    var count: Int { get { return cards.count } }
    
    subscript(index:Int) -> ItemCard {
        get {
            return cards[index]
        }
        set(new) {
            cards.insert(new, at: index)
        }
    }
    
    init(json: [String: Any]) {
        for i in json {
            if let temp = i.value as? [String: Any] {
                let card = ItemCard(json: temp)
                    card.id = i.key
                
                if !(DataSource.shared().user! as! CustomerUser).likedItems.contains(item: card) {
                    self.buffer.append(card)
                }
            }
        }
    }
    
    func append(json: [String: Any]) {
        for i in json {
            if let temp = i.value as? [String: Any] {
                let card = ItemCard(json: temp)
                    card.id = i.key
                if !self.contains(item: card) {
                    self.buffer.append(card)
                }
            }
        }
    }
    
    func append(store: ItemCardStore) {
        for i in store.cards {
            if !self.contains(item: i) {
                if !(DataSource.shared().user! as! CustomerUser).likedItems.contains(item: i) {
                    self.buffer.append(i)
                }
            }
        }
    }
    
    @discardableResult
    func transfer() -> Int {
        let buffCount = buffer.count
        cards.append(contentsOf: buffer)
        buffer.removeAll()
        return buffCount
    }
    
    private func contains(item: ItemCard) -> Bool {
        let cardsContains = cards.contains(where: { $0.id == item.id })
        let bufferContains = buffer.contains(where: { $0.id == item.id })
        return cardsContains || bufferContains
    }
    
}

extension ItemCardStore: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return cards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return CardView(card: cards[index])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
}
