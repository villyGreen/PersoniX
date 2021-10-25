//
//  SignUpViewController.swift
//  PersonX
//
//  Created by zz on 24.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Create Elementsa
    
    let mainTitle = UILabel(textLabel: "Регистрация",
                            fontLabel: UIFont(name: "Gill Sans", size: 30),
                            textAlpha: 0.9, textColor: .black)
    
    let emailLabel = UILabel(textLabel: "Email",
                             fontLabel: UIFont(name: "Gill Sans", size: 22),
                             textAlpha: 0.9, textColor: .black)
    
    let passwordLabel = UILabel(textLabel: "Пароль",
                                fontLabel: UIFont(name: "Gill Sans", size: 22),
                                textAlpha: 0.9, textColor: .black)
    
    let secondPasswordLabel = UILabel(textLabel: "Потвердите пароль",
                                      fontLabel: UIFont(name: "Gill Sans", size: 22),
                                      textAlpha: 0.9, textColor: .black)
    
    let alreadyRegisterlabel = UILabel(textLabel: "Уже зарегистрированы?",
                                       fontLabel: UIFont(name: "Gill Sans", size: 22),
                                       textAlpha: 0.9, textColor: .black)
    
    let registerButton = UIButton(title: "Регистрация",
                                  textColor: .white, BC: .black,
                                  cornerRadius: 25,
                                  isShadow: false,
                                  font: UIFont(name: "Gill Sans", size: 25))
    let inputButton = UIButton()
    
    let mailTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    let passwordTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    let secondPasswrodTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    var activeTextField : UITextField? = nil
    
    deinit {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputButton()
        setupTf()
        setupElements()
        view.backgroundColor = .white
        addNotificationObservers()
        
    }
    
    
    
    @objc private func showDetailVc() {
        createUser()
        
    }
    
    private func addNotificationObservers() {
        
        mailTf.delegate = self
        passwordTf.delegate = self
        secondPasswrodTf.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Register
    private func createUser() {
        guard let email = mailTf.text,let password = passwordTf.text,let confirmPassword = secondPasswrodTf.text else {
            return
        }
        
        if !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
            guard password == confirmPassword else {
                createAlert(title: "Ошибка", message: "Введенные вами пароли не совпадают", completion: nil)
                return
            }
            AuthService.shared.register(email: email,
                                        password: password,
                                        confirmPassword: confirmPassword) { result in
                                            switch result {
                                            case .success(let user):
                                                self.createAlert(title: "Успешно",
                                                                 message: "Аккаунт зарегистрирован", completion: { _ in
                                                                    let vc = DetailPersonViewController(currentUser: user)
                                                                    vc.modalPresentationStyle = .fullScreen
                                                                    self.present(vc,
                                                                                 animated: true,
                                                                                 completion: nil) })
                                                
                                                
                                                
                                                
                                            case .failure(let error):
                                                self.createAlert(title: "Ошибка",
                                                                 message: "Попробуйте еще раз!", completion: nil)
                                                print("Ошибка")
                                                
                                            }
            }
        } else {
            createAlert(title: "Ошибка", message: "Все поля должны быть заполнены", completion: nil)
        }
        
    }
    
    
}





// MARK: - Setup UIElements and their constraints

extension SignUpViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupTf() {
        passwordTf.isSecureTextEntry = true
        secondPasswrodTf.isSecureTextEntry = true
        
    }
    
    private func setupInputButton() {
        registerButton.addTarget(self, action: #selector(showDetailVc), for: .touchUpInside)
        inputButton.setTitle("Войти", for: .normal)
        inputButton.setTitleColor(.red, for: .normal)
        inputButton.titleLabel?.font = UIFont(name: "Gill Sans", size: 22)
        inputButton.alpha = 0.81
    }
    
    private func setupElements() {
        view.addSubview(mainTitle)
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let mailStackVIew = UIStackView(arrangedSubviews: [emailLabel,mailTf])
        mailStackVIew.axis = .vertical
        mailStackVIew.spacing = 20
        
        let passwordStackVIew = UIStackView(arrangedSubviews: [passwordLabel,passwordTf])
        passwordStackVIew.axis = .vertical
        passwordStackVIew.spacing = 20
        
        let confirmPasswordStackVIew = UIStackView(arrangedSubviews: [secondPasswordLabel,secondPasswrodTf])
        confirmPasswordStackVIew.axis = .vertical
        confirmPasswordStackVIew.spacing = 20
        registerButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [mailStackVIew,passwordStackVIew,confirmPasswordStackVIew,registerButton])
        stack.axis = .vertical
        stack.spacing = 40
        
        //
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 110).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        
        let bottomStack = UIStackView(arrangedSubviews: [alreadyRegisterlabel,inputButton])
        bottomStack.axis = .vertical
        bottomStack.spacing = 10
        bottomStack.alignment = .center
        view.addSubview(bottomStack)
        
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 130).isActive = true
        bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
}


extension SignUpViewController: UITextFieldDelegate {
    
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

