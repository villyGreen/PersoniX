//
//  DetailPersonViewController.swift
//  PersonX
//
//  Created by zz on 25.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseAuth


class DetailPersonViewController: UIViewController {
    
    let mainTitle = UILabel(textLabel: "Настройка профиля",
                            fontLabel: UIFont(name: "Gill Sans", size: 30),
                            textAlpha: 0.8, textColor: .black)
    
    let nameAndSurnameLabel = UILabel(textLabel: "Имя и фамилия",
                                      fontLabel: UIFont(name: "Gill Sans", size: 21),
                                      textAlpha: 0.9, textColor: .black)
    
    let aboutYourselfLabel = UILabel(textLabel: "О себе",
                                     fontLabel: UIFont(name: "Gill Sans", size: 21),
                                     textAlpha: 0.9, textColor: .black)
    
    let sexLabel = UILabel(textLabel: "Пол",
                           fontLabel: UIFont(name: "Gill Sans", size: 21),
                           textAlpha: 0.9, textColor: .black)
    
    
    let nameAndSurnameTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    let aboutYourselfTf = UITextField(fontTf: UIFont(name: "Gill Sans", size: 22))
    
    let inputButton = UIButton(title: "Начать", textColor: .red, BC: .white,
                               cornerRadius: 25, isShadow: true,
                               font: UIFont.init(name: "Gill Sans", size: 25))
    
    
    let segmentedControl = UISegmentedControl(items: ["Мужской","Женский"])
    let photoView = addPhotoView()
    var activeTextField: UITextField? = nil
    let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        if let userName = currentUser.displayName {
            nameAndSurnameTf.text = userName
         
            print(currentUser.photoURL)
        }
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupkeyBoardSize()
        setupConstraints()
        setupElements()
    }
}

//MARK: Setup Elements
extension DetailPersonViewController {
    
    func setupElements() {
        segmentedControl.selectedSegmentIndex = 0
        inputButton.addTarget(self, action: #selector(nextVc), for: .touchUpInside)
        photoView.plusButton.addTarget(self, action: #selector(imagePicker), for: .touchUpInside)
    }
    
    
    @objc private func imagePicker() {
        
         let picker = UIImagePickerController()
        picker.allowsEditing = true
               picker.delegate = self
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Фото", style: .default) { _ in
            picker.sourceType = .photoLibrary
            self.present(picker,
                         animated: true,
                         completion: nil)
            
        }
        
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            picker.sourceType = .camera
            self.present(picker,
            animated: true,
            completion: nil)
        }
        
         let cancel = UIAlertAction(title: "Назад", style: .destructive, handler: nil)
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert,
                     animated: true,
                     completion: nil)
    
        
    }
    
    
    @objc private func nextVc() {
        FireStoreService.shared.addDataToDb(id: currentUser.uid,
                                            userName: nameAndSurnameTf.text,
                                            email: currentUser.email!,
                                            
                                            avatarImage: photoView.logo.image,
                                            sex: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex),
                                            description: aboutYourselfTf.text) { result in
                                            switch result {
                                            case .success(let Muser) :
                                                let tabBar = TabBarViewController(user: Muser)
                                                tabBar.modalPresentationStyle = .fullScreen
                                                self.present(tabBar, animated: true, completion: nil)
                                                break;
                                            case .failure(let error):
                                                self.createAlert(title: "Ошибка",
                                                            message: error.localizedDescription, completion: nil)
                                                }
        }
        
    }
    
    func setupConstraints() {
        
        view.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        
        photoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(mainTitle)
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        let nameAndsurnameStack = UIStackView(arrangedSubviews: [nameAndSurnameLabel,nameAndSurnameTf])
        nameAndsurnameStack.axis = .vertical
        nameAndsurnameStack.spacing = 20
        
        let aboutYourSelfStack = UIStackView(arrangedSubviews: [aboutYourselfLabel,aboutYourselfTf])
        aboutYourSelfStack.axis = .vertical
        aboutYourSelfStack.spacing = 20
        
        let sexStack = UIStackView(arrangedSubviews: [sexLabel,segmentedControl])
        sexStack.axis = .vertical
        sexStack.spacing = 20
        
        
        let stackView = UIStackView(arrangedSubviews: [nameAndsurnameStack,aboutYourSelfStack,sexStack,inputButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 40
        inputButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 70).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        
    }
    
    private func setupkeyBoardSize() {
               nameAndSurnameTf.delegate = self
               aboutYourselfTf.delegate = self
               
              NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
              
              NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
               
           }
}

extension DetailPersonViewController : UITextFieldDelegate {
    
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
            self.view.frame.origin.y = 70 - keySize.height
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension DetailPersonViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard  let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        photoView.logo.image = image
    }
}
