//
//  Section Header.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
   static let reuseId = "SectionHeader"
    let title = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    func configureHeader(text: String, font: UIFont?, textColor: UIColor, textAlpha: CGFloat) {
        title.alpha = textAlpha
        title.text = text
        title.font = font
        title.textColor = textColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
