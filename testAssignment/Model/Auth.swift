//
//  Auth.swift
//  testAssignment
//
//  Created by SHREDDING on 17.03.2023.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FirebaseStorage

class User{
    
    let storage = DatabaseItems()
    
    // MARK: - fields
    
    private var firstName:String?
    private var lastName:String?
    private var email:String?
    private var password:String?
    private var uid:String?
    private var crenedtial:AuthCredential?
    private var profilePhoto:UIImage = UIImage(named: "no photo")!
    private var isGoogleUser = false
    private var photoUrl:URL?
    
    public var isGooglePhotoSet = false
    
    public var isLogin = false
    
    // MARK: - set Methods
    
    public func setUserFirstName(firstName:String){
        self.firstName = firstName
    }
    public func setLastName(lastName:String){
        self.lastName = lastName
    }
    public func setEmail(email:String){
        self.email = email
    }
    public func setPassword(password:String){
        self.password = password
    }
    public func setCredential(credential:AuthCredential){
        self.crenedtial = credential
    }
    public func setUid(uid:String){
        self.uid = uid
    }
    public func setProfilePhoto(image:UIImage){
        self.profilePhoto = image
        storage.addPhotoToDatabase(uid: self.getUid(), image: self.getProfilephoto())
    }
    public func setIsUserGoogle(isUserGoogle:Bool){
        self.isGoogleUser = isUserGoogle
    }
    public func setphotoUrl(photoUrl:URL?){
        self.photoUrl = photoUrl
    }
    
    // MARK: - get Methods
    
    public func getFirstName()->String{
        return self.firstName ?? ""
    }
    public func getLastName()->String{
        return self.lastName ?? ""
    }
    public func getEmail()->String{
        return self.email ?? ""
    }
    public func getUid() ->String{
        return self.uid ?? ""
    }
    public func getProfilephoto() ->UIImage{
        return self.profilePhoto
    }
    public func getIsUserGoogle()->Bool{
        return self.isGoogleUser
    }
    public func getphotoUrl()->URL?{
        return self.photoUrl
    }
    
    public func setGooglePhoto(completion: (()->Void)? = nil){
        let request = URLRequest(url: self.getphotoUrl()!)
        
        
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil{
                    print(error)
                }else{
                    self.setProfilePhoto(image: (UIImage(data: data!)!))
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }.resume()
    }
    
    public func setCurrentUser(completion: (()->Void)? = nil){
        guard let user = Auth.auth().currentUser else{ return }
        self.setUid(uid: user.uid)
        
        storage.getUserFirstNameFromDatabase(uid: self.getUid()) { error, result in
            if error != nil{
                print(error)
            }else{
                self.setUserFirstName(firstName: result!)
                print("getted: " + AppDelegate.user.getFirstName())
                
                self.storage.getUserLastNameFromDatabase(uid: self.getUid()) { error, result in
                    if error != nil{
                        print(error)
                    }else{
                        self.setLastName(lastName: result!)
                        
                        self.storage.getPhotoFromDatabase(uid: self.getUid()) { image, error in
                            if error != nil{
                                print(error)
                            }else{
                                if image != nil{
                                    self.profilePhoto = image!
                                }else{
                                    if self.getIsUserGoogle() && self.getphotoUrl() != nil{
                                        self.setGooglePhoto {
                                            completion?()
                                        }
                                    }else{
                                        self.profilePhoto = UIImage(named: "no photo")!
                                        completion?()
                                    }
                                }
                            }
                            completion?()
                        }
                    }
                }
            }
        }
        
        
        self.setEmail(email: (user.email)!)
    }
    
    
    
    // MARK: - Create User
    public func createUserWithEmail(completion:@escaping ((AuthDataResult?,Error?)->Void)){
        Auth.auth().createUser(withEmail: self.email!, password: self.password!) { result, error in
            if (error != nil){
                completion(nil, error)
            }else{
                self.setUid(uid: (result?.user.uid)!)
                self.storage.addUserToDataBase(uid: self.getUid(), firstName: self.getFirstName(), lastName: self.getLastName(), email: self.getEmail(),isGoogleUser: false,urlPhotoGoogle: nil)
                completion(result, nil)
            }
        }
    }
    
    // MARK: - Login
    
    public func logIn(completion:@escaping ((AuthDataResult?,Error?)->Void)) {
        
        self.isLogin = true
        Auth.auth().signIn(withEmail: self.email!, password: self.password!) { result, error in
            if error != nil{
                completion(nil,error)
            }else{
                completion(result,nil)
            }
        }
    }
    public func logInViaGoogle(completion:@escaping ((AuthDataResult?,Error?)->Void)){
        self.isLogin = true
        Auth.auth().signIn(with: crenedtial!) { result, error in
            if error != nil{
                completion(nil,error)
            }else{
                self.setUid(uid: (result?.user.uid)!)
                self.storage.addUserToDataBase(uid: self.getUid(), firstName: self.getFirstName(), lastName: self.getLastName(), email: self.getEmail(), isGoogleUser: true, urlPhotoGoogle: self.getphotoUrl()?.absoluteString)
                completion(result,nil)
                
            }
        }
    }
    
    // MARK: - Delete or modify
    
    public func deletePhoto(){
        storage.deletePhotoFromStorage(uid: self.getUid())
        self.setProfilePhoto(image: UIImage(named: "no photo")!)
    }
    

    // MARK: - validation Funcs
    
    public func isSignIn() -> Bool{
        return Auth.auth().isSignIn(withEmailLink: self.email!)
    }
    
    public func isUserExistByEmail( completion: @escaping ((Bool)->Void) ) {
        Auth.auth().fetchSignInMethods(forEmail: self.email!) { providers, error in
            if error != nil{
                completion(false)
            }else{
                if providers != nil{
                    completion(true)
                }else{
                    completion(false)
                }
                
            }
        }
    }
    
    public func isValidEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.email)
    }
}
