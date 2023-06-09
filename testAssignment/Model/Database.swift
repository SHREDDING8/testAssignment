//
//  Database.swift
//  testAssignment
//
//  Created by SHREDDING on 19.03.2023.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage


class DatabaseItems{
    let storage = Storage.storage()
    
    // MARK: - addUserToDataBase
    public func addUserToDataBase(uid:String,firstName:String,lastName:String,email:String,isGoogleUser:Bool,urlPhotoGoogle:String?){
        let ref = Database.database().reference().child("users")
        ref.child(uid).updateChildValues([
            "firstname":firstName,
            "lastname":lastName,
            "email":email,
            "isGoogleUser":isGoogleUser,
            "urlPhotoGoogle": urlPhotoGoogle as Any
        ])
    }
    // MARK: - addPhotoToDatabase
    public func addPhotoToDatabase(uid:String,image:UIImage){
        let ref = storage.reference().child(uid)
        let uploadData = image.pngData()
        ref.putData(uploadData!) { result, error in
            if error != nil{
                print("DATABASE ERROR: addPhotoToDatabase ")
            }
        }
    }
    // MARK: - getPhotoFromDatabase
    public func getPhotoFromDatabase(uid:String, completion:@escaping ((UIImage?,Error?)->Void)){
        let ref = storage.reference().child(uid)
        ref.getData(maxSize: Int64.max) { data, error in
            if error != nil{
                print("DATABASE ERROR: getPhotoFromDatabase")
                completion(nil,error)
            }
            else{
                completion(UIImage(data: data!),nil)
            }
        }
    }
    
    // MARK: - deletePhotoFromStorage
    public func deletePhotoFromStorage(uid:String){
        let ref = storage.reference().child(uid)
        ref.delete { error in
            if error != nil{
                print("DATABASE ERROR: deletePhotoFromStorage")
            }
        }
    }
    
    // MARK: - getUserFirstNameFromDatabase
    public func getUserFirstNameFromDatabase(uid:String, completion: @escaping ((Error?,String?)->Void)){
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(uid)
        databaseUser.child("firstname").getData { error, dataSnapshot in
            if error != nil{
                print("DATABASE ERROR: getUserFirstNameFromDatabase")
                completion(error,nil)
            }else{
                let firstName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,firstName)
            }
            
        }
        
    }
    // MARK: - getUserLastNameFromDatabase
    public func getUserLastNameFromDatabase(uid:String, completion: @escaping ((Error?,String?)->Void)){
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(uid)
        databaseUser.child("lastname").getData { error, dataSnapshot in
            if error != nil{
                print("DATABASE ERROR: getUserLastNameFromDatabase")
                completion(error,nil)
            }else{
                let lastName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,lastName)
            }
        }
    }
    
    // MARK: - getIsUserGoogleFromDatabase
    public func getIsUserGoogleFromDatabase(uid:String, completion: @escaping ((Error?,Bool?)->Void)){
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(uid)
        databaseUser.child("isGoogleUser").getData { error, dataSnapshot in
            if error != nil{
                print("DATABASE ERROR: getIsUserGoogleFromDatabase")
                completion(error,nil)
            }else{
                let isGoogleUser = dataSnapshot?.value as? Bool ?? false
                completion(nil,isGoogleUser)
            }
        }
    }
    // MARK: - getGoogleUserPhotoFromDatabase
    public func getGoogleUserPhotoFromDatabase(uid:String, completion: @escaping ((Error?,String?)->Void)){
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(uid)
        databaseUser.child("urlPhotoGoogle").getData { error, dataSnapshot in
            if error != nil{
                print("DATABASE ERROR: getGoogleUserPhotoFromDatabase")
                completion(error,nil)
            }else{
                let googlePhoto = dataSnapshot?.value as? String
                completion(nil,googlePhoto)
            }
        }
    }
}
