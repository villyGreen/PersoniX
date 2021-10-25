//
//  UIIimage + Extension.swift
//  PersonX
//
//  Created by zz on 24.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit


extension UIImageView {
    
    convenience init(image: UIImage,contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
    
    convenience init(backgroundColor: UIColor,contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
    }
}
