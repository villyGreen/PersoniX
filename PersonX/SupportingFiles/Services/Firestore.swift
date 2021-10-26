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
    
    var currentUser: ModelUser?
    
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
