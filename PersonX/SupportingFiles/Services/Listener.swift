//
//  Listener.swift
//  PersonX
//
//  Created by zz on 22.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    let db = Firestore.firestore()
    
    var reference: CollectionReference {
        return db.collection("users")
    }
    
    let currentUserId = Auth.auth().currentUser?.uid
    func userObserve(user: [ModelUser],completion: @escaping (Result<[ModelUser],Error>) -> Void) -> ListenerRegistration? {
        var users = user
        let userListener = reference.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let muser = ModelUser(document: diff.document) else { return }
                print("muser email = \(muser.email)")
                   print("muser email = \(muser.avatarStringURL)")
                print("currentId = \(self.currentUserId)")
            
                
                switch diff.type {
                case .added:
                    guard Auth.auth().currentUser?.email != muser.email else { break }
                    users.append(muser)
                    print("userCount = \(users.count)")
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return userListener
    }
    
}
