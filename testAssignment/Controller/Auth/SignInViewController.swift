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
    
    override var preferredStatusBarStyle:UIStatusBarStyle{
        return .darkContent
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var secondName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var logInButton: UILabel!
    
    @IBOutlet weak var signInWithGoogle: UIStackView!
    
    @IBOutlet weak var signInWithApple: UIStackView!
    
    
    @IBOutlet weak var logIn: UILabel!
    
    @IBOutlet weak var loadPage: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViews()
    }
    
    // MARK: - Configuration
    
    fileprivate func configureViews(){
    
        
        let cornerRadius = 15.0
        setCornerRadius(views: [firstName,secondName,email,signInButton], cornerRadius: cornerRadius)
        setPlaceholder(textFields: [firstName,secondName,email], placeholders: ["First name","Last name","Email"])
        
        
        let signInViaGoogleGesture = UITapGestureRecognizer(target: self, action: #selector(signInViaGoogle))
        signInWithGoogle.addGestureRecognizer(signInViaGoogleGesture)
        signInWithGoogle.isUserInteractionEnabled = true
        
        
        
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
    
    // MARK: - Navigation
    
    @objc func goToLogin(){
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        loginViewController.doAferClickSignIn = {
            self.removeAndShowChild(controller: loginViewController)
        }
        
        addAndShowChild(controller: loginViewController)
    }
    
    @IBAction func signIn(_ sender: Any){
        AppDelegate.user = User()
        firstName.resignFirstResponder()
        secondName.resignFirstResponder()
        email.resignFirstResponder()
        
        AppDelegate.user.setEmail(email: self.email.text ?? "")
        AppDelegate.user.setUserFirstName(firstName: firstName.text ?? "")
        AppDelegate.user.setLastName(lastName: secondName.text ?? "")
        
        if textFieldsIsEmpty(){
            errorAlert(title: "Error", message: "Some fields is empty")
            return
        }
        if !AppDelegate.user.isValidEmail(){
            errorAlert(title: "Error", message: "Email incorrect")
            return
        }
        
        let passwordViewController = storyboard?.instantiateViewController(withIdentifier: "passwordViewController") as! passwordViewController
        
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
        
        AppDelegate.user.isUserExistByEmail { [self] isExist in
            if isExist{
                errorAlert(title: "Error", message: "Account with this email exist")
            }else{
                self.addAndShowChild(controller: passwordViewController)
            }
        }
    }
    public func goToMainPage(){
        
        for child in self.children{
            self.removeAndShowChild(controller: child)
        }
        
        
        self.loadPage.layer.opacity = 0
        self.loadPage.isHidden = false
        
        UIView.transition(with: self.loadPage, duration: 0.3,options: .transitionCrossDissolve) {
            self.loadPage.layer.opacity = 1
        }
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        AppDelegate.user.setCurrentUser {
                ApiManager.loadLatest {
                        ApiManager.loadFlashSale {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true) {

                                    UIView.transition(with: self.loadPage, duration: 1,options: .transitionCrossDissolve) {
                                            self.loadPage.layer.opacity = 0
                                        }
                                        self.loadPage.isHidden = true
                                        self.activityIndicator.stopAnimating()
                                }
                                
                            
                        }
                    }
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
    
    
    // MARK: - Google
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
            
            AppDelegate.user.setEmail(email: userGoogle.profile!.email)
            AppDelegate.user.setLastName(lastName: userGoogle.profile?.familyName ?? "")
            AppDelegate.user.setUserFirstName(firstName: userGoogle.profile?.givenName ?? "")
            AppDelegate.user.setCredential(credential: credential)
            print("set: " + AppDelegate.user.getFirstName())
            AppDelegate.user.setIsUserGoogle(isUserGoogle: true)
            AppDelegate.user.setphotoUrl(photoUrl: userGoogle.profile?.imageURL(withDimension: 100))
            
            
            AppDelegate.user.logInViaGoogle { [self] resultLogin, errorlogIn in
                if error != nil{
                }else{
                    self.goToMainPage()
                }
            }
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
    
}

