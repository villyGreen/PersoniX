//
//  Validators.swift
//  PersonX
//
//  Created by zz on 20.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import Foundation
class Validators {
    static func isFiled(username: String?, description: String?, sex: String?)  -> Bool {
        guard let sex = sex,
            let description = description,
            let username = username,
        sex != "" && description != "" && username != "" else {
            return false
        }
        return true
    }
}
