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
    
    
    public func addUserToDataBase(uid:String,firstName:String,lastName:String,email:String){
        let ref = Database.database().reference().child("users")
        ref.child(uid).updateChildValues([
            "firstname":firstName,
            "lastname":lastName,
            "email":email
        ])
    }
    public func addPhotoToDatabase(uid:String,image:UIImage){
        let ref = storage.reference().child(uid)
        let uploadData = image.pngData()
        ref.putData(uploadData!) { result, error in
            if error != nil{
                print(error)
            }else{
                print("success")
            }
        }
    }
    public func getPhotoFromDatabase(uid:String, completion:@escaping ((UIImage?,Error?)->Void)){
        let ref = storage.reference().child(uid)
        ref.getData(maxSize: Int64.max) { data, error in
            if error != nil{
                print(error)
                completion(nil,error)
            }
            else{
                completion(UIImage(data: data!),nil)
            }
        }
    }
    public func deletePhotoFromStorage(uid:String){
        let ref = storage.reference().child(uid)
        ref.delete { error in
            if error != nil{
                print(error)
            }
        }
    }
    
    public func getUserFirstNameFromDatabase(uid:String, completion: @escaping ((Error?,String?)->Void)){
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(uid)
        databaseUser.child("firstname").getData { error, dataSnapshot in
            if error != nil{
                completion(error,nil)
                
            }else{
                let firstName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,firstName)
            }
            
        }

    }
    
    public func getUserLastNameFromDatabase(uid:String, completion: @escaping ((Error?,String?)->Void)){
        let ref = Database.database().reference().child("users")
        
        let databaseUser = ref.child(uid)
        databaseUser.child("lastname").getData { error, dataSnapshot in
            if error != nil{
                completion(error,nil)
            }else{
                let lastName = dataSnapshot?.value as? String ?? "Unknown"
                completion(nil,lastName)
            }
        }
    }
}
