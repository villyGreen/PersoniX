//
//  modelChat.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct ModelChat: Hashable,Decodable  {
    
    var friendUsername: String
    var friendUserImageString: String
    var friendLastMessage: String
    var friendId: String
    
    
    var representation: [String : Any] {
        var rep: [String: Any] = [
            "friendUsername" : friendUsername,
            "friendUserImageString" : friendUserImageString,
            "friendLastMessage" : friendLastMessage,
            "friendId" : friendId
        ]
        
        return rep
    }
    
    
    init?(document:DocumentSnapshot) {
        guard let data = document.data() else { return nil}
        guard let friendUsername = data["friendUsername"] as? String else { return nil}
        guard let friendUserImageString = data["friendUserImageString"] as? String else { return nil}
        guard let friendLastMessage = data["friendLastMessage"] as? String else { return nil}
        guard let friendId = data["friendId"] as? String else { return nil}
        
        self.friendUsername = friendUsername
               self.friendUserImageString = friendUserImageString
               self.friendLastMessage = friendLastMessage
               self.friendId = friendId
        
    }
    
    init(friendUsername: String,friendUserImageString: String,friendLastMessage: String,friendId: String) {
        self.friendUsername = friendUsername
        self.friendUserImageString = friendUserImageString
        self.friendLastMessage = friendLastMessage
        self.friendId = friendId
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: ModelChat,rhs: ModelChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
    
    
}

