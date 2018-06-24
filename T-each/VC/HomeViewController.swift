//
//  HomeViewController.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionTableView: UITableView!
    
    var questions = [Question]()
    var selectQuestion: Question!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        questionTableView.delegate = self
        questionTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestionSegue" {
            let viewController = segue.destination as! QuestionViewController
            viewController.currentQuestion = self.selectQuestion
        }
    }
    
    func fetchData() {
        var keywords = [String]()
        if let keys = UserDefaults.standard.stringArray(forKey: "keyword"){
            keywords = keys
        }else{
            keywords = [""]
        }
        Question.DownloadQuestions(keywords: keywords) { (question) in
            print(question.timestamp)
            self.questions.append(question)
            DispatchQueue.main.async {
                self.questionTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        
        let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.questions[indexPath.row].timestamp))
        let dataformatter = DateFormatter.init()
        dataformatter.timeStyle = .short
        let date = dataformatter.string(from: messageDate)
        cell.categoryLabel.text = questions[indexPath.row].subject
        cell.contentLabel.text = questions[indexPath.row].content
        cell.timeLabel.text = date
        cell.userLabel.text = questions[indexPath.row].user.name
        cell.questionImageView.image = questions[indexPath.row].image
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.estimatedRowHeight = 290.0
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if questions.count > 0{
            self.selectQuestion = self.questions[indexPath.row]
         performSegue(withIdentifier: "showQuestionSegue", sender: nil)
        }
    }
    
    @IBAction func createQuestion() {
        performSegue(withIdentifier: "createQuestionSegue", sender: nil)
    }
}
