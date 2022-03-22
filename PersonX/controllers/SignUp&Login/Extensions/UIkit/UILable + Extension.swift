//
//  UILable + Extension.swift
//  PersonX
//
//  Created by zz on 24.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(textLabel: String, fontLabel: UIFont?, textAlpha: CGFloat, textColor: UIColor) {
        self.init()
        self.text = textLabel
        self.font = fontLabel
        self.tintColor = textColor
        self.alpha = textAlpha
    }
    
}
