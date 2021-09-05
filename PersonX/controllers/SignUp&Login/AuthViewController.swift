//
//  ViewController.swift
//  PersonX
//
//  Created by zz on 24.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: Create UI
    // ImageView
    let imageView = UIImageView(image: #imageLiteral(resourceName: "main logo"), contentMode: .scaleAspectFill)
    
    // labels
    let googleLabel = UILabel(textLabel: "Начните с помощью",
                              fontLabel: UIFont(name: "Gill Sans", size: 21),
                              textAlpha: 0.66, textColor: .black)
    
    let mailLabel = UILabel(textLabel: "Или с помощью",
                            fontLabel: UIFont(name: "Gill Sans", size: 21),
                            textAlpha: 0.66, textColor: .black)
    
    let inputlabel = UILabel(textLabel: "Уже зарегистрированы?",
                             fontLabel: UIFont(name: "Gill Sans", size: 21),
                             textAlpha: 0.66, textColor: .black)
    
    let companyLabel = UILabel(textLabel: "Created by Vitkovskiy",
                               fontLabel: UIFont.init(name: "Heiti Sc", size: 15),
                               textAlpha: 1, textColor: .black)
    
    // buttons
    let googleButton = UIButton(title: "Google", textColor: .black, BC: .white,
                                cornerRadius: 25, isShadow: true,
                                font: UIFont.init(name: "Gill Sans", size: 25))
    
    let mailButton = UIButton(title: "Email", textColor: .white, BC: .black,
                              cornerRadius: 25, isShadow: false,
                              font: UIFont.init(name: "Gill Sans", size: 25))
    
    let inputButton = UIButton(title: "Войти", textColor: .red, BC: .white,
                               cornerRadius: 25, isShadow: true,
                               font: UIFont.init(name: "Gill Sans", size: 25))
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupElements()
        setupButtons()
    }
    
    // MARK: Setup elements
    
    private func setupButtons() {
        mailButton.addTarget(self, action: #selector(showRegisterVC), for: .touchUpInside)
        inputButton.addTarget(self, action: #selector(showInputVc), for: .touchUpInside)
        googleButton.addGoogleLogo()
        mailButton.addMailLogo()
    }
    @objc private func showRegisterVC() {
        let signVc = SignUpViewController()
        
        self.present(signVc, animated: true)
        
    }
    
    @objc private func showInputVc () {
        
        let loginvc = LoginViewController()
        
        self.present(loginvc, animated: true)
        
    }
    
    private func setupElements() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 122).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 323).isActive = true
        
        view.addSubview(companyLabel)
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        companyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        companyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let googleView = CustomView(label: googleLabel, button: googleButton)
        let mailView = CustomView(label: mailLabel, button: mailButton)
        let inputView = CustomView(label: inputlabel, button: inputButton )
        let stackView = UIStackView(arrangedSubviews: [googleView,mailView,inputView])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 40
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 80).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        
        
        
    }
    
    
    
}


