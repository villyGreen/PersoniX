//
//  ActiveChatsCollectionViewCell.swift
//  PersonX
//
//  Created by zz on 02.09.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import SDWebImage

class ActiveChatsCollectionViewCell: UICollectionViewCell, CellConfiguring {
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
                                    startColor: #colorLiteral(red: 0.5600051195, green: 0.5249576435, blue: 0.8549019694, alpha: 1),
                                    endColor: #colorLiteral(red: 1, green: 0.7614787568, blue: 0.6651494798, alpha: 1))
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    func configure<U>(value: U) where U: Hashable {
        guard let activeChat: ModelChat = value as? ModelChat else {
        return
        }
        guard let imageUrl = URL(string: activeChat.friendUserImageString) else { return }
        imageView.sd_setImage(with: imageUrl, completed: nil)
        userName.text = activeChat.friendUsername
        lastMessage.text = activeChat.friendLastMessage
       }
    private func constraints() {
        addSubview(gradientView)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive  = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        let stack = UIStackView(arrangedSubviews: [userName, lastMessage])
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
        gradientView.widthAnchor.constraint(equalToConstant: 7).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
