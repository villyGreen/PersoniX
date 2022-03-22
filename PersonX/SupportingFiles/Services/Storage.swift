//
//  Storage.swift
//  PersonX
//
//  Created by zz on 22.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageServeces {
    static let shared = StorageServeces()
    let storageRef = Storage.storage().reference()
    var reference: StorageReference {
        return storageRef.child("avatars")
    }
    var chatRef: StorageReference {
        return storageRef.child("Chat pictures")
    }
    let currentUser = Auth.auth().currentUser
    func upload(image: UIImage, completion: @escaping ((Result<URL, Error>) -> Void)) {
        guard let _ = image.scaledToSafeUploadSize,
            let imageData = image.jpegData(compressionQuality: 0.4) else {
                return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        print(" currentUserId to storage \(String(describing: currentUser?.uid))")
        reference.child(currentUser!.uid).putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.reference.child(self.currentUser!.uid).downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(url!))
                }
            }
        }
    }
    func uploadPhoto(image: UIImage, chat: ModelChat, completion: @escaping ((Result<URL, Error>) -> Void)) {
        guard let _ = image.scaledToSafeUploadSize, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let uid: String  = Auth.auth().currentUser!.uid
        let chatName = [chat.friendUsername, uid].joined()
        chatRef.child(chatName).child(imageName).putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.chatRef.child(chatName).child(imageName).downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(url!))
            }
        }
    }
    func downloadPhoto(url: URL, completion: @escaping ((Result<UIImage?, Error>) -> Void)) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let size = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: size) { (data, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(UIImage(data: data!)))
        }
    }
}
