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
    var doAferClickSignIn:(()->Void)?
    
    
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signIn: UILabel!
    
    
    let eyeGlobalView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return view
    }()
    
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
    
    
    // MARK: - Configuration
    fileprivate func configureViews(){
        let cornerRadius = 15.0
        eyeGlobalView.addSubview(eyeImageView)
        eyeGlobalView.addSubview(lineimageView)
        
        setCornerRadius(views: [email,password,logInButton], cornerRadius: cornerRadius)
        setPlaceholder(textFields: [email,password], placeholders: ["Email","Password"])
        
        password.rightView = eyeGlobalView
        password.rightViewMode = .always
        
        let gestureEye = UITapGestureRecognizer(target: self, action: #selector(showHidePassword))
        password.rightView!.addGestureRecognizer(gestureEye)
        
        let gestureSignIn = UITapGestureRecognizer(target: self, action: #selector(SignIn))
        signIn.addGestureRecognizer(gestureSignIn)
        
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
    
    
    // MARK: - Actions
    @IBAction func logIn(_ sender: Any) {
        textFieldResign(textFields: [email,password])
        
        AppDelegate.user.setEmail(email: email.text ?? "")
        AppDelegate.user.setPassword(password: password.text ?? "")
        
        AppDelegate.user.logIn { result, error in
            if error != nil{
                self.errorAlert(title: "Error", message: "Wrong Email or password")
            }else{
                (self.parent as! SignInViewController).goToMainPage()
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
    
    fileprivate func textFieldResign(textFields:[UITextField]){
        for textField in textFields{
            textField.resignFirstResponder()
        }
    }
}
