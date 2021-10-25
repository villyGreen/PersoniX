//
//  Auth.swift
//  PersonX
//
//  Created by zz on 18.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn


class AuthService {
    
    static let shared = AuthService()
    
    
    func logIn(email: String,password: String,completion: @escaping (Result<User,Error>) -> Void){
        Auth.auth().signIn(withEmail: email,
                           password: password) { (result, error) in
                            if let result = result {
                                completion(.success(result.user))
                            } else {
                                completion(.failure(error!))
                            }
        }
    }
    
    func googleLogIn(user: GIDGoogleUser?,completion: @escaping (Result<User,Error>) -> Void) {
        
        guard  let authentication = user?.authentication, let idToken = authentication.idToken else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
            
        }
        
    }
    
    
    
    
    
    
    func register(email: String,password: String,confirmPassword: String,completion: @escaping (Result<User,Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email,
                               password: password) { (result, error) in
                                if let result = result {
                                    completion(.success(result.user))
                                } else {
                                    completion(.failure(error!))
                                }
        }
    }
    
    
    
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            guard error == nil else {
                return
            }
            
        }
    }
}

