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
                let storageRef = Storage.storage().reference().child("usersProfilePics").child(user!.uid)
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        let path = metadata?.downloadURL()?.absoluteString
                        let values = ["name": withName, "email": email, "profilePicLink": path!]
                        Firestore.firestore().collection("users").document((user?.uid)!).setData(values, completion: { (err) in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                let userInfo = ["email" : email, "password" : password]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
                            }
                        })
                    }else {
                        print(err?.localizedDescription)
                    }
                })
                
            }
            else {
                print(error?.localizedDescription)
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
                print(error?.localizedDescription)
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
        Firestore.firestore().collection("users").document(forUserID).getDocument { (document, err) in
            if err == nil {
                if let data = document?.data(){
                    let name = data["name"] as! String
                    let email = data["email"] as! String
                    let link = URL.init(string: data["profilePicLink"]! as! String)
                    URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                        if error == nil {
                            let profilePic = UIImage.init(data: data!)
                            let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!)
                            completion(user)
                        }else{
                            print(err?.localizedDescription)
                        }
                    }).resume()
                    
                }else{
                    print("データが取得できません")
                }
                
            }else{
                print(err?.localizedDescription)
            }
        }
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

