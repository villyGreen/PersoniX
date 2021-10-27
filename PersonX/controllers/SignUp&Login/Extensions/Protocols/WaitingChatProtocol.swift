//
//  WaitingChatProtocol.swift
//  PersonX
//
//  Created by zz on 26.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import Foundation



protocol WaitingChatProtocol: class {
    func removeWaitingChat(chat: ModelChat)
    func transformToActiveChat(chat: ModelChat)
}
