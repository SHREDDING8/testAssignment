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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
