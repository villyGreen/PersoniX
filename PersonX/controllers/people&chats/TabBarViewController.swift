//
//  TabBarViewController.swift
//  PersonX
//
//  Created by zz on 27.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    private var user: ModelUser
    
    
    let peopleImage = #imageLiteral(resourceName: "peopleImage")
    let chatsImage = #imageLiteral(resourceName: "chatsImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupTabBar()
        
    }
    
    init(user:ModelUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBar() {
        let peopleVc = configurationController(rootVC: PeopleViewController(user: user),
                                               image: peopleImage,
                                               title: "Люди")
        
        let chatsVc = configurationController(rootVC: ChatsViewController(user: user),
                                              image: chatsImage,
                                              title: "Чаты")
        viewControllers = [peopleVc,chatsVc]
        tabBar.tintColor = #colorLiteral(red: 0.412116766, green: 0.321144253, blue: 0.6445029378, alpha: 1)
        
    }
    
    private func configurationController(rootVC: UIViewController,image: UIImage,title: String) -> UIViewController {
        let vc = UINavigationController(rootViewController: rootVC)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
}
