//
//  Question.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase

class Question {
    var name: String
    var content: String
    var subject: String
    var image: UIImage
    var timestamp: Int
    
    init(name: String, content: String, subject: String, image: UIImage, timestamp: Int) {
        self.name = name
        self.content = content
        self.subject = subject
        self.image = image
        self.timestamp = timestamp
    }
    
    class func registerQuestion(name: String, content: String, subject: String, image: UIImage) {
        let params:[String : Any] = ["name": name, "content": content, "subject": subject, "image": image]
        Firestore.firestore().collection("questions").addDocument(data: params) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
            }
        }
    }
    
    class func DownloadAllQuestions(completion: @escaping ([Question]) -> Swift.Void){
        Firestore.firestore().collection("questions").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var questions = [Question]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as! String
                    let content = data["content"] as! String
                    let subject = data["subject"] as! String
                    let image = data["image"] as! UIImage
                    let timestamp = data["timestamp"] as! Int
                    let question = Question.init(name: name, content: content, subject: subject, image: image, timestamp: timestamp)
                    questions.append(question)
                }
                completion(questions)
            }
        }

    }
    
    
}
