//
//  Message.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase

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
    
    class func sendMessage(userID: String, content: String, image: UIImage, questionID: String, timestamp: Int){
        let params:[String: Any] = ["userID": userID, "content": content, "image": image, "questionID": questionID, "timestamp": timestamp]
        Firestore.firestore().collection("messages").addDocument(data: params) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
            }
        }
    }
    
    class func DownloadAllMessage(questionID: String, completion: @escaping ([Message]) -> Swift.Void){
        Firestore.firestore().collection("messages").whereField("questionID", isEqualTo: questionID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                var messages = [Message]()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let userID =  data["userID"] as! String
                    let content = data["content"] as! String
                    let image = data["image"] as! UIImage
                    let timestamp = data["timestamp"] as! Int
                    let message = Message.init(userID: userID, content: content, image: image, timestamp: timestamp)
                    messages.append(message)
                }
                completion(messages)
            }
        }
    }
}
