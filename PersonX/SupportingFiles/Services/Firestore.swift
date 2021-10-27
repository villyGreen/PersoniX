//
//  Firestore.swift
//  PersonX
//
//  Created by zz on 19.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//
import  FirebaseAuth
import FirebaseFirestore



class FireStoreService {
    
    static let shared = FireStoreService()
    let db = Firestore.firestore()
    
    
    var userRef: CollectionReference {
        return db.collection("users")
    }
    
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
           return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
       }
    
    
    var currentUser: ModelUser!
    
    func getUserData(user: User, completion: @escaping ((Result<ModelUser,Error>) -> Void)) {
        let documentUser = userRef.document(user.uid)
        
        documentUser.getDocument { (document, error) in
            guard let document = document, document.exists else {
                completion(.failure(UserError.notFoundUser))
                return
            }
            guard  let user = ModelUser(document: document) else {
                completion(.failure(UserError.ConvertDocumentError))
                return
            }
            self.currentUser = user
            completion(.success(user))
        }
    }
    
    
    
    func createWaitingChat(message: String, receiver: ModelUser, completion: @escaping ((Result<Void,Error>) -> Void)) {
        
        let reference = db.collection(["users",receiver.id,"WaitingChats"].joined(separator: "/"))
        var messageRef = reference.document(currentUser!.id).collection("messages")
        let message = ModelMessage(user: currentUser!, content: message)
        print(message.id)
        
        let chat = ModelChat(friendUsername: currentUser!.username,
                             friendUserImageString: currentUser!.avatarStringURL,
                             friendLastMessage: message.content,
                             friendId: currentUser!.id)
        
        reference.document(currentUser!.id).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
            }
            completion(.success(Void()))
            
        }
    }
    
    func deleteWaitingChat(chat: ModelChat, completion: @escaping ((Result<Void,Error>) -> Void)) {
        print("1")
        let reference = db.collection(["users",currentUser!.id,"WaitingChats"].joined(separator: "/"))
        reference.document(chat.friendId).delete { (error) in
            
            if let error = error {
                completion(.failure(error))
         
                return
            }
  
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    
    
    func deleteMessages(chat: ModelChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
                
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getWaitingChatMessages(chat: ModelChat, completion: @escaping (Result<[ModelMessage], Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [ModelMessage]()
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = ModelMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    
    func changeToActive(chat: ModelChat, completion: @escaping (Result<Void, Error>) -> Void) {
        print("2")

        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {

                    case .success():
                        self.createActiveChat(chat: chat,
                                         messages: messages) { (result) in
                                            switch result {

                                            case .success():
                                                completion(.success(Void()))
                                            case .failure(let error):
                                                completion(.failure(error))
                                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func createActiveChat(chat: ModelChat,messages: [ModelMessage], completion: @escaping (Result<Void, Error>) -> Void) {
         let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
        activeChatsRef.document(chat.friendId).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for message in messages {
                messageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func addDataToDb(id: String,userName: String?,email: String,avatarImage: UIImage?,sex:String?,description: String?,completion: @escaping ((Result<ModelUser,Error>) -> Void)) {
        guard Validators.isFiled(username: userName, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != UIImage(named: "account logog") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        var user = ModelUser(userName: userName!,
                             avatarStringURL:"NO PHOTO",
                             email: email,
                             description: description!,
                             sex: sex!,
                             id: id)
        StorageServeces.shared.upload(image: avatarImage!) { (result) in
            
            switch result {
                
            case .success(let url):
                user.avatarStringURL = url.absoluteString
                self.userRef.document(user.id).setData(user.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
