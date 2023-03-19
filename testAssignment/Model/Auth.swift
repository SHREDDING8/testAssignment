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
    
    private var userFirstName:String?
    private var userLastName:String?
    private var email:String?
    private var password:String?
    private var uid:String?
    private var crenedtial:AuthCredential?
    
    public func setUserFirstName(firstName:String){
        self.userFirstName = firstName
    }
    public func setLastName(lastName:String){
        self.userLastName = lastName
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
    public func getFirstName()->String?{
        return self.userFirstName
    }
    public func getLastName()->String?{
        return self.userLastName
    }
    
    
    
    public func createUserWithEmail(completion:@escaping ((AuthDataResult?,Error?)->Void)){
        Auth.auth().createUser(withEmail: self.email!, password: self.password!) { result, error in
            if (error != nil){
                completion(nil, error)
            }else{
                self.uid = result?.user.uid
                self.addUserToDataBase()
                completion(result, nil)
            }
        }
    }
    
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
    
    public func addUserToDataBase(){
        let ref = Database.database().reference().child("users")
        ref.child(self.uid!).updateChildValues([
            "firstname":self.userFirstName!,
            "lastname":userLastName!,
            "email":self.email!
        ])
    }
    
    public func isSignIn() -> Bool{
        return Auth.auth().isSignIn(withEmailLink: self.email!)
    }
    
    public func isUserExistByEmail( completion: @escaping ((Bool)->Void) ) {
        Auth.auth().fetchSignInMethods(forEmail: self.email!) { providers, error in
            if error != nil{
                print(error)
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
    
    public func getUserFirstName(completion: @escaping ((Error?,String?)->Void)){
        let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(user!.uid)
        databaseUser.child("firstname").getData { error, dataSnapshot in
            if error != nil{
                print(error)
                completion(error,nil)
                
            }else{
                self.userFirstName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,self.userFirstName)
            }
            
        }

    }
    
    public func getUserLastName(completion: @escaping ((Error?,String?)->Void)){
        let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(user!.uid)
        databaseUser.child("lastname").getData { error, dataSnapshot in
            if error != nil{
                print(error)
                completion(error,nil)
            }else{
                self.userLastName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,self.userLastName)
            }
           
        }
    }
    
}
