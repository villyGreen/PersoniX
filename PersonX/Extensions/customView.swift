//
//  customView.swift
//  PersonX
//
//  Created by zz on 24.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit


class CustomView: UIView {
    
    init(label: UILabel,button: UIButton) {
        
        super.init(frame: .zero)
        self.addSubview(label)
        self.addSubview(button)
        self.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        self.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
    
    
    
}
