//
//  LoginViewController.swift
//  PersonX
//
//  Created by zz on 25.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Create UI elements
    let mainTitle = UILabel(textLabel: "Авторизация",
                            fontLabel: UIFont(name: "Gill Sans", size: 30),
                            textAlpha: 0.9, textColor: .black)
    
    let googleLabel = UILabel(textLabel: "Войти с помощью",
                              fontLabel: UIFont(name: "Gill Sans", size: 21),
                              textAlpha: 0.66, textColor: .black)
    
    let googleButton = UIButton(title: "Google", textColor: .black, BC: .white,
                                cornerRadius: 25, isShadow: true,
                                font: UIFont.init(name: "Gill Sans", size: 25))
    
    let emailLabel = UILabel(textLabel: "Email",
                             fontLabel: UIFont(name: "Gill Sans", size: 22),
                             textAlpha: 0.9, textColor: .black)
    
    let passwordLabel = UILabel(textLabel: "Пароль",
                                fontLabel: UIFont(name: "Gill Sans", size: 22),
                                textAlpha: 0.9, textColor: .black)
    
    let mailTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    let passwordTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    
    let alreadyNoRegisterlabel = UILabel(textLabel: "Нет аккаунта?",
                                         fontLabel: UIFont(name: "Gill Sans", size: 22),
                                         textAlpha: 0.9, textColor: .black)
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Gill Sans", size: 22)
        button.alpha = 0.81
        
        
        return button
    }()
    
    let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Gill Sans", size: 22)
        button.alpha = 0.81
        
        return button
    }()
    
    var activeTextField: UITextField? = nil
    
    deinit {
           dismiss(animated: true)
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupElements()
        setupkeyBoardSize()
    }
    
   
    private func setupkeyBoardSize() {
        passwordTf.delegate = self
        mailTf.delegate = self
        
       NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       
       NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
}





extension LoginViewController {

    // MARK: Setup  UI Elements
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func showVc() {
        let signUpVc = SignUpViewController()
        dismiss(animated: true)
    }
    
    func setupElements() {
        registrationButton.addTarget(self, action: #selector(showVc), for: .touchUpInside)
        passwordTf.isSecureTextEntry = true
        googleButton.addGoogleLogo()
        view.addSubview(mainTitle)
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let googleCustomView = CustomView(label: googleLabel, button: googleButton)
        
        let mailStackView = UIStackView(arrangedSubviews: [emailLabel,mailTf])
        mailStackView.axis = .vertical
        mailStackView.spacing = 20
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel,passwordTf])
        passwordStack.axis = .vertical
        passwordStack.spacing = 20
        
        logInButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        // MARK: StackView
        let stackView = UIStackView(arrangedSubviews: [googleCustomView,mailStackView,passwordStack,logInButton])
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 40
        
        
        //MARK: Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 110).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        
        
        // MARK: BottomStacKView
        let bottomStack = UIStackView(arrangedSubviews: [alreadyNoRegisterlabel,registrationButton])
        view.addSubview(bottomStack)
        bottomStack.axis = .horizontal
        bottomStack.spacing = 1
        bottomStack.alignment = .center
        registrationButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        
        //MARK: Constraints
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25).isActive = true
        bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75).isActive = true
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        guard  let keySize =  (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        var shouldMoveViewUp = false
        
        if let activeTF = activeTextField {
            let bottomOfTf = activeTF.convert(activeTF.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keySize.height
            
            if bottomOfTf > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if shouldMoveViewUp {
            self.view.frame.origin.y = 100 - keySize.height
        }
        
    }
    
    @objc func keyBoardWillHide(notification : Notification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    
    
    
    
    
    
}
