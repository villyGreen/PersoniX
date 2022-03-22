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

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
struct ModelMessage: Hashable, MessageType {
    var image: UIImage?
    var downloadUrl: URL?
    var sender: SenderType
    var sentDate: Date
    var content: String
    var id: String?
    var representation: [String: Any] {
        var rep: [String: Any] = [
            "senderId": sender.senderId,
            "sentDate": sentDate,
            "senderUsername": sender.displayName
        ]
        if let url = downloadUrl {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        return rep
    }
    var kind: MessageKind {
        if let image = image {
            let mediaImage = ImageItem(url: nil,
                                       image: nil,
                                       placeholderImage: image,
                                       size: image.size)
            return .photo(mediaImage)
        } else {
            return .text(content)
        }
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
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let senderId = data["senderId"] as? String else { return nil}
        guard let sendTime = data["sentDate"] as? Timestamp else { return nil}
        guard let senderUserName = data["senderUsername"] as? String else { return nil}
//        guard let content = data["content"] as? String else { return nil}
        self.id = document.documentID
        self.sender = Sender(senderId: senderId, displayName: senderUserName)
        self.sentDate = sendTime.dateValue()
        if let content = data["content"] as? String {
            self.content = content
            downloadUrl = nil
        } else if let downloadUrl = data["url"] as? String, let url = URL(string: downloadUrl) {
            self.downloadUrl = url
            self.content = ""
        } else {
            return nil
        }
    }
    init(image: UIImage, user: ModelUser) {
         self.sender = Sender(senderId: user.id, displayName: user.username)
        self.image = image
        self.content = ""
        self.id = nil
        sentDate = Date()
    }
    init(user: ModelUser, content: String) {
        self.content = content
        self.sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
}
extension ModelMessage: Comparable {
    static func < (lhs: ModelMessage, rhs: ModelMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
