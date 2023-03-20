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
    
    public func setCurrentUser(completion: (()->Void)? = nil){
        guard let user = Auth.auth().currentUser else{ return }
        self.setUid(uid: user.uid)
        
        storage.getUserFirstNameFromDatabase(uid: self.getUid()) { error, result in
            if error != nil{
                print(error)
            }else{
                self.setUserFirstName(firstName: result!)
                
                self.storage.getUserLastNameFromDatabase(uid: self.getUid()) { error, result in
                    if error != nil{
                        print(error)
                    }else{
                        self.setLastName(lastName: result!)
                        
                        self.storage.getPhotoFromDatabase(uid: self.getUid()) { image, error in
                            if error != nil{
                                print(error)
                            }else{
                                self.profilePhoto = image ?? UIImage(named: "no photo")!
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
                self.storage.addUserToDataBase(uid: self.getUid(), firstName: self.getFirstName(), lastName: self.getLastName(), email: self.getEmail())
                completion(result, nil)
            }
        }
    }
    
    // MARK: - Login
    
    public func logIn(completion:@escaping ((AuthDataResult?,Error?)->Void)) {
        
        Auth.auth().signIn(withEmail: self.email!, password: self.password!) { result, error in
            if error != nil{
                completion(nil,error)
            }else{
                completion(result,nil)
            }
        }
    }
    public func logInViaGoogle(completion:@escaping ((AuthDataResult?,Error?)->Void)){
        Auth.auth().signIn(with: crenedtial!) { result, error in
            if error != nil{
                completion(nil,error)
            }else{
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
