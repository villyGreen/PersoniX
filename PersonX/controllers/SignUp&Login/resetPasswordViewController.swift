//
//  resetPasswordViewController.swift
//  PersonX
//
//  Created by zz on 19.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit




class resetPasswordViewController: UIViewController {
    
    
    let mainTitle = UILabel(textLabel: "Сброс пароля",
                            fontLabel: UIFont(name: "Gill Sans", size: 30),
                            textAlpha: 0.9, textColor: .black)
    
    let emailLabel = UILabel(textLabel: "Email",
                             fontLabel: UIFont(name: "Gill Sans", size: 22),
                             textAlpha: 0.9, textColor: .black)
    
    let mailTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сброс", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Gill Sans", size: 22)
        button.alpha = 0.81
        
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupElements()
     
    }
    
    
    private func setupElements() {
        resetButton.addTarget(self,
                              action: #selector(buttonFunc), for: .touchUpInside)
    }
    @objc private func buttonFunc() {
        reset()
    }
    
    private func setupConstraints() {
        view.addSubview(mainTitle)
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let mailStackView = UIStackView(arrangedSubviews: [emailLabel,mailTf])
        mailStackView.axis = .vertical
        mailStackView.spacing = 20
        
        let stackView = UIStackView(arrangedSubviews: [mailStackView,resetButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 40
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 170).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
    }
    
    
    private func reset() {
        
        if let email = mailTf.text {
            guard !email.isEmpty else {
                createAlert(title: "Ошибка",
                            message: "Все поля должны быть заполнены",
                            completion: nil)
                return
            }
            AuthService.shared.resetPassword(email: email)
            createAlert(title: "Успешно", message: "На ваш адрес электронной почты отправлена ссылка на сброс пароля") { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
