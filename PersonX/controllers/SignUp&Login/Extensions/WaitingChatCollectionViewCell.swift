//
//  WaitingChatCollectionViewCell.swift
//  PersonX
//
//  Created by zz on 03.09.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class WaitingChatCollectionViewCell: UICollectionViewCell,CellConfiguring {
    
    
    static var reuseID = "WaitingChatCell"
    let imageView = UIImageView()
    
//    func configure(value: ModelChat) {
//        imageView.image = UIImage(named: value.userImageString)
//    }
    
    func configure<U>(value: U) where U : Hashable {
    guard let waitingChat: ModelChat = value as? ModelChat else {
              return
              }
         imageView.image = UIImage(named: waitingChat.userImageString)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func constraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 78).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
