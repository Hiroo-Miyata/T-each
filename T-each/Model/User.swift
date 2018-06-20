//
//  User.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    
    init(name: String, email: String, id: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
    
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                user?.sendEmailVerification(completion: nil)
                let values = ["name": withName, "email": email]
                Firestore.firestore().collection("users").document((user?.uid)!).setData(values, completion: { (err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("成功しました")
                    }
                })
                
            }
            else {
                completion(false)
            }
        })
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
       
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            let data = snapshot?.documents
            
        }
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }
}
