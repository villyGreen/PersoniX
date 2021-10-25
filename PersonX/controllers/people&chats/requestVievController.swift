//
//  requestVievController.swift
//  PersonX
//
//  Created by zz on 18.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit




class RequetsViewController: UIViewController {
    
 
    let image = UIImageView()
    let containerView = UIView()
    let nameLabel = UILabel()
    let warningLabel = UILabel()
    let acceptButton = UIButton(title: "Принять",
                                textColor: .white,
                                BC: #colorLiteral(red: 0.4734251262, green: 1, blue: 0.1964273022, alpha: 1),
                                cornerRadius: 15,
                                isShadow: true,
                                font: UIFont(name: "Avenir", size: 18))
    
    let denyButton = UIButton(title: "Отказ",
                              textColor: .red,
                              BC: .clear,
                              cornerRadius: 15,
                              isShadow: true,
                              font: UIFont(name: "Avenir",
                                           size: 18))
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        view.addSubview(image)
         view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(warningLabel)
      
        
               image.image = #imageLiteral(resourceName: "human6")
               image.contentMode = .scaleAspectFill
               image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
               image.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
               image.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
               image.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.translatesAutoresizingMaskIntoConstraints = false
       
        
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = #colorLiteral(red: 0.968990624, green: 0.9776130319, blue: 0.9988356233, alpha: 1)
        
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 206).isActive = true
        
        nameLabel.text = "Julia Beria"
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        
        nameLabel.textColor = .black
        
        warningLabel.text = "Принять запрос на общение?"
        warningLabel.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        warningLabel.textColor = .black
        warningLabel.numberOfLines = 0
        
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
         nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
         nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 30).isActive = true
        
        
            warningLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 30).isActive = true
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
       let buttonStackView = UIStackView(arrangedSubviews: [acceptButton,denyButton])
        containerView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        
        denyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 20).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
    }
    
    
    
}
