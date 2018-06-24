//
//  Message.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class Message: NSObject {
    let userID: String
    let content: String
    let image: UIImage
    let timestamp: Int
    
    init(userID: String, content: String, image: UIImage, timestamp: Int){
        self.userID = userID
        self.content = content
        self.image = image
        self.timestamp = timestamp
    }
    
    class func sendMessage(userID: String, content: String, image: UIImage, questionID: String, timestamp: Int,completion: @escaping (Bool) -> Swift.Void){
        let storageRef = Storage.storage().reference().child("messagePics").child(questionID).child(userID).child(content)
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
            if err == nil {
                let path = metadata?.downloadURL()?.absoluteString
                let params:[String: Any] = ["userID": userID, "content": content, "image": path!, "questionID": questionID, "timestamp": timestamp]
                Firestore.firestore().collection("messages").addDocument(data: params) { (err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }else{
                print(err?.localizedDescription)
                completion(false)
            }
        })
        
    }
    
    class func DownloadAllMessage(questionID: String, completion: @escaping (Message) -> Swift.Void){
        Firestore.firestore().collection("messages").whereField("questionID", isEqualTo: questionID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let userID =  data["userID"] as! String
                    let content = data["content"] as! String
                    let link = data["image"] as! String
                    let imagelink = URL.init(string: link)
                    let timestamp = data["timestamp"] as! Int
                    Alamofire.request(imagelink!).response{ response in
                        if let data = response.data{
                            let image = UIImage.init(data: data)
                            User.info(forUserID: userID, completion: { (user) in
                                let message = Message.init(userID: userID, content: content, image: image!, timestamp: timestamp)
                                completion(message)
                            })
                        }
                        
                    }
                }
            }
        }
    }
}

