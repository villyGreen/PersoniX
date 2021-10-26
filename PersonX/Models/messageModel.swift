//
//  messageModel.swift
//  PersonX
//
//  Created by zz on 26.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit





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
            "senderUserName" : senderUsername,
            "content" : content
        ]
        
        return rep
    }
    
    init(user: ModelUser,content: String) {
        self.content = content
        senderId = user.id
        sendTime = Date()
        senderUsername = user.username
        id = nil
    }
    
    
}
