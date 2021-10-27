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
                
                
                switch diff.type {
                case .added:
                    guard Auth.auth().currentUser?.email != muser.email else { break }
                    users.append(muser)
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
    
    
    func waitingChatListener(chat: [ModelChat],completion: @escaping ((Result<[ModelChat],Error>) -> Void)  ) -> ListenerRegistration {
        var chats = chat
        let reference = db.collection(["users",currentUserId!,"WaitingChats"].joined(separator: "/"))
        let chatListener = reference.addSnapshotListener { (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let chat = ModelChat(document: diff.document) else { return }
                print(chat.friendUsername)
                 print(chat.friendLastMessage)
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
                
            }
            completion(.success(chats))
        }
        
        return chatListener
    }
    
    
    
    
    
}
