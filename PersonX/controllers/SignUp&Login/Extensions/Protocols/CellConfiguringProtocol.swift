//
//  CellConfiguringProtocol.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import Foundation

protocol CellConfiguring {
    
    static var reuseID: String { get }
    func configure<U: Hashable>(value: U)
}
