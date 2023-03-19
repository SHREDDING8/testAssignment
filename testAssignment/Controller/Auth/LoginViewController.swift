//
//  LoginViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 16.03.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - My variables
    var isHidePassword = true
    let user = User()
    var doAferClickSignIn:(()->Void)?
    
    
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signIn: UILabel!
    
    
    let eyeImageView:UIImageView = {
        let view = UIImageView(frame: CGRect(x: -20, y: -7, width: 15, height: 15))
        view.image =  UIImage(named: "eye")
        view.contentMode = .scaleAspectFill
        return view
        
    }()
    
    let lineimageView:UIImageView = {
        let view = UIImageView(frame: CGRect(x: -21, y: -9, width: 18, height: 18))
        view.image =  UIImage(named: "line")
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()

        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func configureViews(){
        let textFieldCornerRadius = CGFloat(15)
        let logInButtonCornerRadius = CGFloat(15)
        let placeHolderAttrubites = NSAttributedString(
            string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        
        
        email.layer.masksToBounds = true
        password.layer.masksToBounds = true
        logInButton.layer.masksToBounds = true
        
        email.layer.cornerRadius = textFieldCornerRadius
        password.layer.cornerRadius = textFieldCornerRadius
        logInButton.layer.cornerRadius = logInButtonCornerRadius
        
        
        let gestureSignIn = UITapGestureRecognizer(target: self, action: #selector(SignIn))
        signIn.addGestureRecognizer(gestureSignIn)
        
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        view.addSubview(eyeImageView)
        view.addSubview(lineimageView)
        
        password.rightView = view
        password.rightViewMode = .always
        
        email.attributedPlaceholder = placeHolderAttrubites
        password.attributedPlaceholder = placeHolderAttrubites
        email.placeholder = "Email"
        password.placeholder = "Password"
        
        
        
        email.delegate = self
        password.delegate = self
        
        
        let gestureEye = UITapGestureRecognizer(target: self, action: #selector(showHidePassword))
        
        password.rightView!.addGestureRecognizer(gestureEye)
        
    }
    
    @IBAction func logIn(_ sender: Any) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        user.setEmail(email: email.text!)
        user.setPassword(password: password.text!)
        user.logIn { result, error in
            if error != nil{
                print(error)
                self.errorAlert(title: "Error", message: "Wrong Email or password")
            }else{
                print(result?.user.email)
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func SignIn(){
        doAferClickSignIn?()
    }
    @objc func showHidePassword(){
        self.lineimageView.isHidden =  !self.lineimageView.isHidden
        self.password.isSecureTextEntry = !self.password.isSecureTextEntry
        isHidePassword = !isHidePassword
    }
    
    // MARK: - Alerts
    
    fileprivate func errorAlert(title:String,message:String){
        let alert = UIAlertController(title:title , message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(actionOk)
        self.present(alert, animated: true)
    }
}


// MARK: - textField Delegate
extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.restorationIdentifier == "email"{
            password.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        return true
    }
}
