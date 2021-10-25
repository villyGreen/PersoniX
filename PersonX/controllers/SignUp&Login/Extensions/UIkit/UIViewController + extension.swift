//
//  UIViewController + extension.swift
//  PersonX
//
//  Created by zz on 16.10.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit




extension UIViewController {
    
    func configureCell<T:CellConfiguring,U: Hashable>(collectionView : UICollectionView,cellType: T.Type,model: U,indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("Unknown id cell")
        }
        cell.configure(value: model)
        return cell
    }
    
    
    func createAlert(title:String,message: String,completion:((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let OkButton = UIAlertAction(title: "Ок",
                                     style: .default,
                                     handler: completion)
        
        
        
         alertController.addAction(OkButton)
       
        self.present(alertController,
                     animated: true,
                     completion: nil)
        
    }
}
