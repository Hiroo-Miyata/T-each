//
//  KeywordViewController.swift
//  T-each
//
//  Created by hiro on 2018/06/24.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit

class KeywordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var keywords = ["数学", "国語", "英語", "理科", "社会"]
    var selectKeyword = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath)
        cell.textLabel?.text = keywords[indexPath.row]
        if let select = UserDefaults.standard.stringArray(forKey: "keyword"){
            selectKeyword = select
        }else {
            selectKeyword = []
        }
        for keyword in selectKeyword{
            if keyword == keywords[indexPath.row]{
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let select = UserDefaults.standard.stringArray(forKey: "keyword"){
            selectKeyword = select
        }else {
            selectKeyword = []
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                selectKeyword.remove(at: selectKeyword.index(of: keywords[indexPath.row])!)
                UserDefaults.standard.setValue(selectKeyword, forKey: "keyword")
            } else {
                cell.accessoryType = .checkmark
                selectKeyword.append(keywords[indexPath.row])
                UserDefaults.standard.setValue(selectKeyword, forKey: "keyword")
            }
        }
        self.dismiss(animated: false, completion: nil)
    }

}
