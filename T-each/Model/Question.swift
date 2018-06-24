

//
//  Question.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class Question {
    var user: User
    var id: String
    var content: String
    var subject: String
    var image: UIImage
    var timestamp: Int
    
    init(user: User, id: String, content: String, subject: String, image: UIImage, timestamp: Int) {
        self.user = user
        self.id = id
        self.content = content
        self.subject = subject
        self.image = image
        self.timestamp = timestamp
    }
    
    class func registerQuestion(userID: String, content: String, subject: String, image: UIImage, timestamp: Int, completion: @escaping (Bool) -> Swift.Void) {
        let storageRef = Storage.storage().reference().child("questionPics").child(userID).child(content)
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
            if err == nil {
                let path = metadata?.downloadURL()?.absoluteString
                let params:[String : Any] = ["userID": userID, "content": content, "subject": subject, "image": path!, "timestamp": timestamp]
                Firestore.firestore().collection("questions").addDocument(data: params) { (err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                        completion(false)
                    } else {
                        print("register successed!!!")
                        completion(true)
                    }
                }
            }else{
                print(err?.localizedDescription)
                completion(false)
            }
        })
    }
    
    class func DownloadQuestions(keywords: [String],completion: @escaping (Question) -> Swift.Void){
        let QuestionRef = Firestore.firestore().collection("questions").order(by: "timestamp", descending: true)
        if keywords == [""]{
            Firestore.firestore().collection("questions").limit(to: 10).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        print(document.data()["timestamp"] as! Int)
                        let data = document.data()
                        let userID = data["userID"] as! String
                        let id = document.documentID
                        let content = data["content"] as! String
                        let subject = data["subject"] as! String
                        let link = data["image"] as! String
                        let imagelink = URL.init(string: link)
                        let timestamp = data["timestamp"] as! Int
                        Alamofire.request(link).response{ response in
                            if let data = response.data{
                                let image = UIImage.init(data: data)
                                User.info(forUserID: userID, completion: { (user) in
                                    let question = Question.init(user: user, id: id, content: content, subject: subject, image: image!, timestamp: timestamp)
                                    completion(question)
                                })
                            }
                            
                        }
                    }
                }
            }
        }else {
            for keyword in keywords{
                QuestionRef.whereField("subject", isEqualTo: keyword).getDocuments(){(querySnapshot, err) in
                    if let err = err{
                        print("Error getting documents: \(err)")
                    }else{
                        for document in querySnapshot!.documents {
                            print(document.data()["timestamp"] as! Int)
                            let data = document.data()
                            let userID = data["userID"] as! String
                            let id = document.documentID
                            let content = data["content"] as! String
                            let subject = data["subject"] as! String
                            let link = data["image"] as! String
                            let imagelink = URL.init(string: link)
                            let timestamp = data["timestamp"] as! Int
                            Alamofire.request(link).response{ response in
                                if let data = response.data{
                                    let image = UIImage.init(data: data)
                                    User.info(forUserID: userID, completion: { (user) in
                                        let question = Question.init(user: user, id: id, content: content, subject: subject, image: image!, timestamp: timestamp)
                                        completion(question)
                                    })
                                }
                                
                            }
                        }
                    }
                }
            }
            
        }
        
        
        
        
    }
    
    
}

