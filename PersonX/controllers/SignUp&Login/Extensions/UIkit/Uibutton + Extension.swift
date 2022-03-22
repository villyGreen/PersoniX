//
//  Uibutton + Extension.swift
//  PersonX
//
//  Created by zz on 24.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, textColor: UIColor, BC: UIColor, cornerRadius: CGFloat, isShadow: Bool, font: UIFont?) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.titleLabel?.font = font
        self.backgroundColor = BC
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = 4
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    func addGoogleLogo() {
        let googleLogo = UIImageView(image: #imageLiteral(resourceName: "google loho"), contentMode: .scaleAspectFit)
        googleLogo.translatesAutoresizingMaskIntoConstraints = false
        googleLogo.heightAnchor.constraint(equalToConstant: 28).isActive = true
        googleLogo.widthAnchor.constraint(equalToConstant: 28).isActive = true
        self.addSubview(googleLogo)
        googleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        googleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    func addMailLogo() {
        let mailogo = UIImageView(image: #imageLiteral(resourceName: "mail logo"), contentMode: .scaleAspectFit)
        mailogo.translatesAutoresizingMaskIntoConstraints = false
        mailogo.heightAnchor.constraint(equalToConstant: 28).isActive = true
        mailogo.widthAnchor.constraint(equalToConstant: 28).isActive = true
        self.addSubview(mailogo)
        mailogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        mailogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
