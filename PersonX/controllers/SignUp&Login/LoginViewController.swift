//
//  LoginViewController.swift
//  PersonX
//
//  Created by zz on 25.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

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
    
    let forgotPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Gill Sans", size: 20)
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
        setupInputButton()
    }
    
    //MARK: LogIn
    private func LogIn() {
        guard let email = mailTf.text,let password = passwordTf.text else {
            return
        }
        
        if !email.isEmpty && !password.isEmpty  {
            AuthService.shared.logIn(email: email,
                                     password: password) { result in
                                        switch result {
                                        case .success(let user):
                                            FireStoreService.shared.getUserData(user: user) { (result) in
                                                switch result {
                                                    
                                                case .success(let user):
                                                    let tabBar = TabBarViewController(user: user)
                                                    tabBar.modalPresentationStyle = .fullScreen
                                                    self.present(tabBar,
                                                                 animated: true,
                                                                 completion: nil)
                                                case .failure(_):
                                                    let dv = DetailPersonViewController(currentUser: user)
                                                    dv.modalPresentationStyle = .fullScreen
                                                    self.present(dv,
                                                                 animated: true,
                                                                 completion: nil)
                                                }
                                            }
                                           
                                            
                                        case .failure(_):
                                            self.createAlert(title: "Ошибка", message: "Неправильный адрес эл.почты или пароль", completion: nil)
                                            
                                        }
            }
        } else {
             self.createAlert(title: "Ошибка", message: "Необходимо ввести все поля", completion: nil)
        }
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
        dismiss(animated: true)
    }
    @objc private func resetPassword() {
        let vc = resetPasswordViewController()
        self.present(vc,
                     animated: true,
                     completion: nil)
    }
    
    @objc private func googleIn() {
           guard let clientID = FirebaseApp.app()?.options.clientID else { return }
           let config = GIDConfiguration(clientID: clientID)
           GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
               if let error = error {
                   return
               } else {
                   AuthService.shared.googleLogIn(user: user) { (result) in
                       switch result {
                           
                       case .success(let user):
                           FireStoreService.shared.getUserData(user: user) { (result) in
                               switch result {
                                   
                               case .success(let user):
                                   let tabBar = TabBarViewController(user: user)
                                   tabBar.modalPresentationStyle = .fullScreen
                                   self.present(tabBar,
                                                animated: true,
                                                completion: nil)
                               case .failure(let error):
                                   let detailVc = DetailPersonViewController(currentUser: user)
                                   detailVc.modalPresentationStyle = .fullScreen
                                   self.present(detailVc,
                                                animated: true,
                                                completion: nil)
                               }
                           }
                       case .failure(let error):
                           self.createAlert(title: "Ошибка",
                                       message: error.localizedDescription,
                                       completion: nil)
                       }
                   }
               }
           }
       }
    
    
    
    
    func setupElements() {
        registrationButton.addTarget(self, action: #selector(showVc), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleIn), for: .touchUpInside)
        passwordTf.isSecureTextEntry = true
        forgotPassword.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
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
        
        view.addSubview(forgotPassword)
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        forgotPassword.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 13).isActive = true
        forgotPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        forgotPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        
        // MARK: BottomStacKView
        let bottomStack = UIStackView(arrangedSubviews: [alreadyNoRegisterlabel,registrationButton])
        view.addSubview(bottomStack)
        bottomStack.axis = .horizontal
        bottomStack.spacing = 1
        bottomStack.alignment = .center
        registrationButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        
        //MARK: Constraints
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.topAnchor.constraint(equalTo: forgotPassword.bottomAnchor, constant: 20).isActive = true
        bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75).isActive = true
    }
    private func setupInputButton() {
        logInButton.addTarget(self,
                              action: #selector(nextVc), for: .touchUpInside)
    }
    @objc private func nextVc() {
        LogIn()
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
