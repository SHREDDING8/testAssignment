//
//  Page1ViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

class Page1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppDelegate.isfirstLogin{
            AppDelegate.isfirstLogin = !AppDelegate.isfirstLogin
            
            AppDelegate.user.setCurrentUser()
            
        }
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
