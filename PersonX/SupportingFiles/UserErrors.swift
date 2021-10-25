//
//  UserErrors.swift
//  PersonX
//
//  Created by zz on 19.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case notFoundUser
    case ConvertDocumentError
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Загрузите вашу фотографию", comment: "")
        case .notFoundUser:
            return NSLocalizedString("Невозможно найти User", comment: "")
        case .ConvertDocumentError:
             return NSLocalizedString("Невозможно конвертировать документ в модель", comment: "")
        }
    }
    
    
}
