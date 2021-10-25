//
//  ProfileViewController.swift
//  PersonX
//
//  Created by zz on 17.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import SDWebImage




class ProfileViewController: UIViewController {
    
    
    let image = UIImageView()
    let containerView = UIView()
    let nameLabel = UILabel()
    let aboutMeLabel = UILabel()
    var textField = CustomTextField()
    var activeTextField: UITextField? = nil
    var user: ModelUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupkeyBoardSize()
        actions()
        
    }
    
    init?(user: ModelUser) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        let imageURl = URL(string: user.avatarStringURL)
        image.sd_setImage(with: imageURl, completed: nil)
        nameLabel.text = user.username
        aboutMeLabel.text = user.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupConstraints() {
        
        view.addSubview(image)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
        
        
        image.contentMode = .scaleAspectFill
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = #colorLiteral(red: 0.968990624, green: 0.9776130319, blue: 0.9988356233, alpha: 1)
        
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 206).isActive = true
        
        
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        
        nameLabel.textColor = .black
        
        
        aboutMeLabel.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        aboutMeLabel.textColor = .black
        aboutMeLabel.numberOfLines = 0
        
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 30).isActive = true
        
        aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 30).isActive = true
        
        
        textField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 12).isActive = true
        textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25).isActive = true
        textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        
        
        
    }
    
    private func actions() {
        textField.rightButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    @objc private func sendMessage() {
        guard let message = textField.text,message != ""  else { return }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    private func setupkeyBoardSize() {
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
}


extension ProfileViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
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
            self.view.frame.origin.y = 50 - keySize.height
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
