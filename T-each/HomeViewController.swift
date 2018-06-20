//
//  HomeViewController.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTableView.delegate = self
        questionTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 44.0
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "question", sender: nil)
    }
}
