//
//  UserModel.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseFirestore
struct ModelUser: Hashable, Decodable {
    var username: String
    var avatarStringURL: String
    var email: String
    var description: String
    var sex: String
    var id: String
    var representation: [String: Any] {
        var rep = ["userName": username]
        rep["sex"] = sex
        rep["description"] = description
        rep["email"] = email
        rep["id"] = id
        rep["avatarStringURL"] = avatarStringURL
        return rep
    }
    init(userName: String, avatarStringURL: String, email: String, description: String, sex: String, id: String) {
        self.username = userName
        self.avatarStringURL = avatarStringURL
        self.email = email
        self.description = description
        self.id = id
        self.sex = sex
    }
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil}
        guard let userName = data["userName"] as? String else { return nil}
        guard let avatarStringURL = data["avatarStringURL"] as? String else { return nil}
        guard let email = data["email"] as? String else { return nil}
        guard let description = data["description"] as? String else { return nil}
        guard let sex = data["sex"] as? String else { return nil}
        guard let id = data["id"] as? String else { return nil}
        self.username = userName
        self.avatarStringURL = avatarStringURL
        self.email = email
        self.description = description
        self.sex = sex
        self.id = id
    }
    init?(document: QueryDocumentSnapshot) {
         let  data = document.data()
        guard let userName = data["userName"] as? String else { return nil}
        guard let avatarStringURL = data["avatarStringURL"] as? String else { return nil}
        guard let email = data["email"] as? String else { return nil}
        guard let description = data["description"] as? String else { return nil}
        guard let sex = data["sex"] as? String else { return nil}
        guard let id = data["id"] as? String else { return nil}
        self.username = userName
        self.avatarStringURL = avatarStringURL
        self.email = email
        self.description = description
        self.sex = sex
        self.id = id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ModelUser, rhs: ModelUser) -> Bool {
        return lhs.id == rhs.id
    }
    func contains(searchText: String?) -> Bool {
        guard let searchText = searchText else {
            return true
        }
        if searchText.isEmpty {
            return true
        }
        let capitalizedText = searchText.capitalized
        return username.capitalized.contains(capitalizedText)
    }
}
