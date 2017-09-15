//
//  CustomStorageDelegate.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 13.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

protocol CustomStorageDelegate: NSObjectProtocol {
    
    func customStorage(didUpdatedIn index: Int)
    
}
