//
//  UIDeviceExtension.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 16.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    
    enum ScreenType: String {
        case iPhone4_less
        case iPhone5_5c_5s
        case iPhone6_7
        case iPhoneP
        case Unknown
    }
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_less
        case 1136:
            return .iPhone5_5c_5s
        case 1334:
            return .iPhone6_7
        case 1920: //fallthrough
            return .iPhoneP
        case 2208:
            return .iPhoneP
        default:
            return .Unknown
        }
    }
    
}
