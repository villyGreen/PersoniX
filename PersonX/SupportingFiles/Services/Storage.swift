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
    
    let currentUser = Auth.auth().currentUser
    
    
    func upload(image: UIImage,completion: @escaping ((Result<URL,Error>) -> Void)) {
        guard let scaledImage = image.scaledToSafeUploadSize, let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        print(" currentUserId to storage \(currentUser?.uid)")
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
}
