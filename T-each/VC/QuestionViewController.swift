//
//  QuestionViewController.swift
//  T-each
//
//  Created by hiro on 2018/06/21.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    var currentQuestion: Question?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = currentQuestion?.id
        fetchData(questionID: id!)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createMessageSegue" {
            let viewController = segue.destination as! CreateMessageViewController
            viewController.currentQuestion = self.currentQuestion
        }
    }
    
    
    func fetchData(questionID: String) {
        Message.DownloadAllMessage(questionID: questionID) { (message) in
            self.messages.append(message)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messages.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval((self.currentQuestion?.timestamp)!))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.categoryLabel.text = currentQuestion?.subject
            cell.contentLabel.text = currentQuestion?.content
            cell.timeLabel.text = date
            cell.userLabel.text = currentQuestion?.user.name
            cell.questionImageView.image = currentQuestion?.image
            cell.updateConstraintsIfNeeded()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
            let count = indexPath.row - 1
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.messages[count].timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.contentLabel.text = messages[count].content
            cell.answerImageView.image = messages[count].image
            cell.userNameLabel.text = messages[count].userID
            cell.userImageView.image = UIImage.init(named: "profile pic")
            cell.timestampLabel.text = date
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 226
        }else{
            return 176
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 226
        }else{
            return 176
        }
    }
    
    @IBAction func createMessage() {
        performSegue(withIdentifier: "createMessageSegue", sender: nil)
    }
    
    
    
}
