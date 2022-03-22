//
//  CustomTextField.swift
//  PersonX
//
//  Created by zz on 18.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
class CustomTextField: UITextField {
    let leftImage = UIImageView(image: #imageLiteral(resourceName: "smileLogo"), contentMode: .scaleAspectFill)
    let rightButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = "Write something..."
        layer.cornerRadius = 30
        borderStyle = .roundedRect
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        rightButton.setImage(UIImage(named: "sendButton"), for: .normal)
        rightView = rightButton
        rightView?.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        rightViewMode = .always
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        leftImage.heightAnchor.constraint(equalToConstant: 19).isActive = true
         leftImage.widthAnchor.constraint(equalToConstant: 19).isActive = true
        leftView = leftImage
        leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        leftViewMode = .always
        font = UIFont(name: "Avenir", size: 15)
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
