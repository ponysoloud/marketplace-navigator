//
//  UIImageExtension.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 18.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import UIKit

extension UIImage {
    var isDark: Bool {
        get {
            return self.cgImage?.isDark ?? false
        }
    }
}
