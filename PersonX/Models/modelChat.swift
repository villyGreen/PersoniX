//
//  modelChat.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

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
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: ModelChat,rhs: ModelChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
    
    
}

