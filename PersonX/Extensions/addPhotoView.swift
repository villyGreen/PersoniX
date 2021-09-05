//
//  addPhotoView.swift
//  PersonX
//
//  Created by zz on 25.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit



class addPhotoView: UIView {
    
    let logo: UIImageView = {
        let photoLogo = UIImageView(image: #imageLiteral(resourceName: "account logog"), contentMode: .scaleAspectFill)
        photoLogo.clipsToBounds = true
        return photoLogo
    }()
    
    let plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(#imageLiteral(resourceName: "add button"), for: .normal)
        plusButton.tintColor = .black
        return plusButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logo)
        addSubview(plusButton)
        setupConstraints()
        
        
        
    }
    
    
    // MARK: SetupConstraints
    func setupConstraints() {
        logo.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        logo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 125).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        
        plusButton.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 0).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: logo.bottomAnchor ).isActive = true
        //        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        self.bottomAnchor.constraint(equalTo: logo.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = logo.frame.width / 2
    }
    
    
    
}
