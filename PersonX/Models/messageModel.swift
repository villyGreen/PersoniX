//
//  messageModel.swift
//  PersonX
//
//  Created by zz on 26.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseFirestore





struct ModelMessage: Hashable {
    
    var content: String
    var senderId : String
    var sendTime: Date
    var senderUsername: String
    var id: String?
    
    var representation: [String : Any] {
        var rep: [String: Any] = [
            "senderId" : senderId,
            "sendTime" : sendTime,
            "senderUsername" : senderUsername,
            "content" : content
        ]
        
        return rep
    }
    
    
    var messageId: String {
          return id ?? UUID().uuidString
      }
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(messageId)
//    }
//
//    static func == (lhs: ModelMessage, rhs: ModelMessage) -> Bool {
//        return lhs.messageId == rhs.messageId
//    }
    
    
    init?(document:QueryDocumentSnapshot) {
        
        let data = document.data()
        guard let senderId = data["senderId"] as? String else { return nil}
        guard let sendTime = data["sendTime"] as? Timestamp else { return nil}
        guard let senderUserName = data["senderUsername"] as? String else { return nil}
        guard let content = data["content"] as? String else { return nil}
   
        self.id = document.documentID
        self.content = content
        self.senderUsername = senderUserName
        self.sendTime = sendTime.dateValue()
        self.senderId = senderId
        
    }
    
    
    init(user: ModelUser,content: String) {
        self.content = content
        senderId = user.id
        sendTime = Date()
        senderUsername = user.username
        id = nil
    }
    
    
    
//    func hash(into hasher: inout Hasher) {
//           hasher.combine(id)
//       }
//       
//       static func == (lhs: ModelMessage,rhs: ModelMessage) -> Bool {
//           return lhs.id == rhs.id
//    }
    
    
}
