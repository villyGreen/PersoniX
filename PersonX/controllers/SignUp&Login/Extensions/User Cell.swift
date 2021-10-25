//
//  User Cell.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell,CellConfiguring {
    
    let userImage = UIImageView(backgroundColor: .systemFill,
                                contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(textLabel: "text",
                                fontLabel: UIFont(name: "Heiti SC", size: 18),
                                textAlpha: 0.8,
                                textColor: .black)
    let containerView = UIView()
    static var reuseID = "UserCell"
    
    
    
    override func prepareForReuse() {
        userImage.image = nil
    }
    
    func configure<U>(value: U) where U : Hashable {
        guard let user:ModelUser = value as? ModelUser else {
            return
        }
        userNameLabel.text = user.username
        let imageUrl = URL(string: user.avatarStringURL)
        userImage.sd_setImage(with: imageUrl, completed: nil)
    }
    
    private func setupConstraints() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        containerView.addSubview(userImage)
        containerView.addSubview(userNameLabel)
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        userImage.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        userImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        userImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        userImage.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10).isActive = true
        
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemFill
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
