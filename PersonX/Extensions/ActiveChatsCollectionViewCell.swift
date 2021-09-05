//
//  ActiveChatsCollectionViewCell.swift
//  PersonX
//
//  Created by zz on 02.09.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

protocol CellConfiguring {
    
    static var reuseID: String { get }
    func configure(value: ModelChat)
}



class ActiveChatsCollectionViewCell: UICollectionViewCell,CellConfiguring {
    
    static var reuseID = "ActiveChatCell"
    
    
    
    
    
    let imageView = UIImageView()
    let lastMessage = UILabel(textLabel: "How are you",
                              fontLabel: UIFont(name: "Verdana",
                                                size: 16),
                              textAlpha: 0.8, textColor: .black)
    
    let userName = UILabel(textLabel: "Username",
                           fontLabel: UIFont(name: "Heiti SC",
                                             size: 18),
                           textAlpha: 0.6, textColor: .black)
    
    let gradientView = GradientView(from: .topTrailing,
                                    to: .bottomLeading,
                                    startColor: #colorLiteral(red: 0.8549019694, green: 0.332742636, blue: 0.82783012, alpha: 1),
                                    endColor: #colorLiteral(red: 0.6899093367, green: 1, blue: 0.8336385141, alpha: 1))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
    }
    
    
    func configure(value: ModelChat) {
        imageView.image = UIImage(named: value.userImageString)
        userName.text = value.username
        lastMessage.text = value.lastMessage
    }
    
    private func constraints() {
        addSubview(gradientView)
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive  = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        let stack = UIStackView(arrangedSubviews: [userName,lastMessage])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gradientView.translatesAutoresizingMaskIntoConstraints  = false
        gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        gradientView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
