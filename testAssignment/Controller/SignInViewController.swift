//
//  ViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 15.03.2023.
//

import UIKit

class SignInViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var secondName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var logInButton: UILabel!
    
    @IBOutlet weak var signInWithGoogle: UIStackView!
    
    @IBOutlet weak var signInWithApple: UIStackView!
    
    
    @IBOutlet weak var logIn: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViews()
    }
    
    fileprivate func configureViews(){
        let textFieldCornerRadius = CGFloat(15)
        let signInButtonCornerRadius = CGFloat(15)
        let placeHolderAttrubites = NSAttributedString(
            string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        
        firstName.layer.masksToBounds = true
        secondName.layer.masksToBounds = true
        email.layer.masksToBounds = true
        signInButton.layer.masksToBounds = true
        
        firstName.layer.cornerRadius = textFieldCornerRadius
        secondName.layer.cornerRadius = textFieldCornerRadius
        email.layer.cornerRadius = textFieldCornerRadius
        signInButton.layer.cornerRadius = signInButtonCornerRadius
        
        firstName.attributedPlaceholder = placeHolderAttrubites
        secondName.attributedPlaceholder = placeHolderAttrubites
        email.attributedPlaceholder = placeHolderAttrubites
        firstName.placeholder = "First name"
        secondName.placeholder = "Second name"
        email.placeholder = "Email"
        
        
        logIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLogin)))
        
    }
    
    @objc func goToLogin(){
        
        let srotyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }


}

