//
//  LoginViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 16.03.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var logInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()

        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func configureViews(){
        
        
        
        let textFieldCornerRadius = CGFloat(15)
        let logInButtonCornerRadius = CGFloat(15)
        
        
        firstName.layer.masksToBounds = true
        password.layer.masksToBounds = true
        logInButton.layer.masksToBounds = true
        
        firstName.layer.cornerRadius = textFieldCornerRadius
        password.layer.cornerRadius = textFieldCornerRadius
        logInButton.layer.cornerRadius = logInButtonCornerRadius
        
        
        
        
        let eyeImageView = UIImageView(frame: CGRect(x: -20, y: -7, width: 15, height: 15))
        eyeImageView.image =  UIImage(named: "eye")
        
        let lineimageView = UIImageView(frame: CGRect(x: -21, y: -9, width: 18, height: 18))
        lineimageView.image = UIImage(named: "line")
        
        eyeImageView.contentMode = .scaleAspectFill
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        view.addSubview(eyeImageView)
        view.addSubview(lineimageView)
        
        password.rightView = view
        password.rightViewMode = .always
        
    }
    
}
