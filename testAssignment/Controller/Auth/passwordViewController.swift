//
//  passwordViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 17.03.2023.
//

import UIKit

class passwordViewController: UIViewController {
    
    // MARK: - constants
    
    let user:User = User()
    var doAfterClickLogin: (()->Void)?
    var doAfterBack: (()->Void)?
    
    // MARK: - outlets
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordTwo: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var logIn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    
    // MARK: - Configuration
    
    fileprivate func configureViews(){
        print(123)
        let textFieldCornerRadius = CGFloat(15)
        let signInButtonCornerRadius = CGFloat(15)
        let placeHolderAttrubites = NSAttributedString(
            string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        
        password.layer.masksToBounds = true
        passwordTwo.layer.masksToBounds = true
        signIn.layer.masksToBounds = true
        
        password.layer.cornerRadius = textFieldCornerRadius
        passwordTwo.layer.cornerRadius = textFieldCornerRadius
        signIn.layer.cornerRadius = signInButtonCornerRadius
        
        password.attributedPlaceholder = placeHolderAttrubites
        passwordTwo.attributedPlaceholder = placeHolderAttrubites
        
        password.placeholder = "Enter password"
        passwordTwo.placeholder = "Repeat password"
        
        password.delegate = self
        passwordTwo.delegate = self
        
        logIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLogin)))
    }

    
    // MARK: - Sign In
    
    @IBAction func signIn(_ sender: Any) {
        password.resignFirstResponder()
        passwordTwo.resignFirstResponder()
        
        if !isValidPassword(){
            let alert = UIAlertController(title: "Error", message: "invalid password", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(alertOk)
            self.present(alert, animated: true)
            return
        }
        user.setPassword(password: password.text!)
        
        user.createUserWithEmail { result, error in
            if (error != nil){
                print(error!)
            }else{
                print(result?.user.uid ?? "")
                self.user.logIn { result, error in
                    if error != nil{
                        print(error)
                    }else{
                        print(result?.user.email)
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    
    // MARK: - Navigation
    
    @objc func goToLogin(){
        UIView.transition(with: self.view, duration: 0.5,options: .transitionCrossDissolve) {
            self.doAfterClickLogin?()
        }
    }


    @IBAction func backTransition(_ sender: Any) {
        UIView.transition(with: self.view, duration: 0.5,options: .transitionCrossDissolve) {
            self.doAfterBack?()
        }
        
    }
    
    
}


// MARK: - TextFieldDelegate
extension passwordViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.restorationIdentifier == "password"{
            passwordTwo.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    // MARK: - PasswordValid
    fileprivate func isValidPassword() -> Bool{
        if (password.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")).count)! < 8{
            return false
        }
        if password.text != passwordTwo.text{
            return false
        }
        return true
    }
}
