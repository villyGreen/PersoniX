//
//  TabBarViewController.swift
//  PersonX
//
//  Created by zz on 27.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let peopleImage = #imageLiteral(resourceName: "peopleImage")
    let chatsImage = #imageLiteral(resourceName: "chatsImage")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()

    }
    

    private func setupTabBar() {
        
        let peopleVc = configurationController(rootVC: PeopleViewController(),
                                               image: peopleImage,
                                               title: "People")
        
        let chatsVc = configurationController(rootVC: ChatsViewController(),
                                             image: chatsImage,
                                             title: "Chats")
     viewControllers = [peopleVc,chatsVc]
        tabBar.tintColor = #colorLiteral(red: 0.6593477938, green: 0.2814485019, blue: 1, alpha: 1)
    }
    
    private func configurationController(rootVC: UIViewController,image: UIImage,title: String) -> UIViewController {
        let vc = UINavigationController(rootViewController: rootVC)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }

}
