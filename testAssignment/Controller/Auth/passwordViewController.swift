//
//  passwordViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 17.03.2023.
//

import UIKit

class passwordViewController: UIViewController {
    
    // MARK: - constants
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
        let cornerRadius = 15.0
        
        setCornerRadius(views: [password,passwordTwo,signIn], cornerRadius: cornerRadius)
        
        setPlaceholder(textFields: [password,passwordTwo], placeholders: ["Enter password","Repeat password"])
        
        logIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLogin)))
    }
    
    fileprivate func setCornerRadius(views:[UIView],cornerRadius:Double){
        for view in views{
            view.layer.masksToBounds = true
            view.layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    fileprivate func setPlaceholder(textFields:[UITextField],placeholders:[String]){
        let placeHolderAttrubites = NSAttributedString(
            string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        for index in 0..<textFields.count{
            textFields[index].attributedPlaceholder = placeHolderAttrubites
            textFields[index].placeholder = placeholders[index]
        }
    }
    
    
    // MARK: - Sign In
    
    @IBAction func signIn(_ sender: Any) {
        textFieldResign(textFields: [password,passwordTwo])
        
        AppDelegate.user.setPassword(password: password.text ?? "")
        
        if !isValidPassword(){
            errorAlert(title: "Error" , message: "invalid password")
            return
        }
        
        AppDelegate.user.createUserWithEmail { result, error in
            if (error != nil){
            }else{
                AppDelegate.user.logIn { result, error in
                    if error != nil{
                    }else{
                        (self.parent as! SignInViewController).goToMainPage()
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
    
    
    // MARK: - Alerts
    
    fileprivate func errorAlert(title:String,message:String){
        let alert = UIAlertController(title:title , message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(actionOk)
        self.present(alert, animated: true)
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
    fileprivate func textFieldResign(textFields:[UITextField]){
        for textField in textFields{
            textField.resignFirstResponder()
        }
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
