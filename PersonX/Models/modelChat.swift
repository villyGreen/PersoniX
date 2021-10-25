//
//  modelChat.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

struct ModelChat: Hashable,Decodable  {
    
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ModelChat,rhs: ModelChat) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    }

