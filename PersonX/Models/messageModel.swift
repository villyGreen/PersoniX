//
//  messageModel.swift
//  PersonX
//
//  Created by zz on 26.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit




struct ModelMessage: Hashable, MessageType {
    
    
    
    
    var sender: SenderType
    var sentDate: Date
    var content: String
    var id: String?
    
    var representation: [String : Any] {
        var rep: [String: Any] = [
            "senderId" : sender.senderId,
            "sentDate" : sentDate,
            "senderUsername" : sender.displayName,
            "content" : content
        ]
        
        return rep
    }
    
    
    var kind: MessageKind {
        return .text(content)
    }
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    
    static func == (lhs: ModelMessage, rhs: ModelMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    
    init?(document:QueryDocumentSnapshot) {
        
        let data = document.data()
        guard let senderId = data["senderId"] as? String else { return nil}
        guard let sendTime = data["sendTime"] as? Timestamp else { return nil}
        guard let senderUserName = data["senderUsername"] as? String else { return nil}
        guard let content = data["content"] as? String else { return nil}
        
        self.id = document.documentID
        self.content = content
        self.sender = Sender(senderId: senderId, displayName: senderUserName)
        self.sentDate = sendTime.dateValue()
        
    }
    
    
    init(user: ModelUser,content: String) {
        self.content = content
        self.sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
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
