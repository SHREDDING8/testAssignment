//
//  Auth.swift
//  testAssignment
//
//  Created by SHREDDING on 17.03.2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class User{
    
    // MARK: - fields
    
    private var firstName:String?
    private var lastName:String?
    private var email:String?
    private var password:String?
    private var uid:String?
    private var crenedtial:AuthCredential?
    
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
    
    
    
    // MARK: - Create User
    public func createUserWithEmail(completion:@escaping ((AuthDataResult?,Error?)->Void)){
        Auth.auth().createUser(withEmail: self.email!, password: self.password!) { result, error in
            if (error != nil){
                completion(nil, error)
            }else{
                self.setUid(uid: (result?.user.uid)!)
                self.addUserToDataBase()
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
    
    // MARK: - Database
    
    public func addUserToDataBase(){
        let ref = Database.database().reference().child("users")
        ref.child(self.uid!).updateChildValues([
            "firstname":self.firstName!,
            "lastname":lastName!,
            "email":self.email!
        ])
    }
    
    // MARK: - getting From Database
    
    public func getUserFirstNameFromDatabase(completion: @escaping ((Error?,String?)->Void)){
        let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(user!.uid)
        databaseUser.child("firstname").getData { error, dataSnapshot in
            if error != nil{
                completion(error,nil)
                
            }else{
                self.firstName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,self.firstName)
            }
            
        }

    }
    
    public func getUserLastNameFromDatabase(completion: @escaping ((Error?,String?)->Void)){
        let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(user!.uid)
        databaseUser.child("lastname").getData { error, dataSnapshot in
            if error != nil{
                completion(error,nil)
            }else{
                self.lastName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,self.lastName)
            }
           
        }
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
