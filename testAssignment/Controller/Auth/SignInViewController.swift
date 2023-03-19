//
//  ViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 15.03.2023.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class SignInViewController: UIViewController {
    
    
    let user = User()
    
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
    
    // MARK: - Configuration
    
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
        secondName.placeholder = "Last name"
        email.placeholder = "Email"
        
        firstName.delegate = self
        secondName.delegate = self
        email.delegate = self
        
        
        let signInViaGoogleGesture = UITapGestureRecognizer(target: self, action: #selector(signInViaGoogle))
        signInWithGoogle.addGestureRecognizer(signInViaGoogleGesture)
        signInWithGoogle.isUserInteractionEnabled = true
        
        
        
        logIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLogin)))
        
    }
    
    // MARK: - Navigation
    
    @objc func goToLogin(){
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        loginViewController.doAferClickSignIn = {
            self.removeAndShowChild(controller: loginViewController)
        }
        
        addAndShowChild(controller: loginViewController)
    }
    
    @IBAction func signIn(_ sender: Any){
        firstName.resignFirstResponder()
        secondName.resignFirstResponder()
        email.resignFirstResponder()
        if textFieldsIsEmpty(){
            let alert = UIAlertController(title: "Error", message: "Some fields is empty", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(alertOk)
            self.present(alert, animated: true)
            return
        }
        if !isValidEmail(){
            let alert = UIAlertController(title: "Error", message: "Email incorrect", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(alertOk)
            self.present(alert, animated: true)
            return
        }
        
        
        let passwordViewController = storyboard?.instantiateViewController(withIdentifier: "passwordViewController") as! passwordViewController
        
        passwordViewController.user.setUserFirstName(firstName: firstName.text!)
        passwordViewController.user.setLastName(lastName: secondName.text!)
        passwordViewController.user.setEmail(email: email.text!)
        
        passwordViewController.doAfterBack = {
            self.removeAndShowChild(controller: passwordViewController)
        }
        passwordViewController.doAfterClickLogin = {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            loginViewController.doAferClickSignIn = {
                self.removeAndShowChild(controller: loginViewController)
            }
            
            self.addAndShowChild(controller: loginViewController)
            self.removeAndShowChild(controller: passwordViewController)
            
        }
        
        passwordViewController.user.isUserExistByEmail { isExist in
            if isExist{
                let alert = UIAlertController(title: "Error", message: "Account with this email exist", preferredStyle: .alert)
                let alertOk = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(alertOk)
                self.present(alert, animated: true)
                
            }else{
                self.addAndShowChild(controller: passwordViewController)
            }
            
        }
        
        
    }
    
    // MARK: - Childs
    
    fileprivate func addAndShowChild(controller:UIViewController){
        self.addChild(controller)
        UIView.transition(with: self.view, duration: 0.5,options: .transitionCrossDissolve) {
            self.view.addSubview(controller.view)
        }
    }
    
    fileprivate func removeAndShowChild(controller:UIViewController){
        
        UIView.transition(with: self.view, duration: 0.5,options: .transitionCrossDissolve) {
            controller.view.removeFromSuperview()
        }
        controller.removeFromParent()
    }
    
    
    // MARK: - google
    @objc public func signInViaGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [self] result, error in
          
            guard error == nil else {
            return
          }

          guard let userGoogle = result?.user,
            let idToken = userGoogle.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: userGoogle.accessToken.tokenString)
          // ...
            
            self.user.setEmail(email: userGoogle.profile!.email)
            self.user.setLastName(lastName: userGoogle.profile?.familyName ?? "")
            self.user.setUserFirstName(firstName: userGoogle.profile?.givenName ?? "")
            self.user.setCredential(credential: credential)
            
            user.logInViaGoogle { [self] resultLogin, errorlogIn in
                if error != nil{
                    print(errorlogIn)
                }else{
                    user.setUid(uid: (resultLogin?.user.uid)!)
                    user.addUserToDataBase()
                    self.dismiss(animated: true)
                }
            }
            
        }
    }
    
    
    
    
}

// MARK: -TextField Delegate

extension SignInViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.restorationIdentifier == "firstName"{
            secondName.becomeFirstResponder()
        }else if textField.restorationIdentifier == "secondName"{
            email.becomeFirstResponder()
        }else{
            email.resignFirstResponder()
        }
        return true
    }
    
    
    // MARK: - TextField Validation
    
    fileprivate func textFieldsIsEmpty() -> Bool{
        if firstName.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) == "" || firstName.text == nil{
            return true
        } else if secondName.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) == "" || secondName.text == nil{
            return true
        } else if email.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) == "" || email.text == nil {
            return true
        }
        return false
    }
    
    fileprivate func isValidEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email.text)
    }
    
}

