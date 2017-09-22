//
//  StringExtension.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 21.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
