//
//  MenuUITabBarController.swift
//  testAssignment
//
//  Created by SHREDDING on 18.03.2023.
//

import UIKit

class MenuUITabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = tabBar.frame.height / 2 - 2
    }
    
}
