//
//  ProfileViewController.swift
//  T-each
//
//  Created by hiro on 2018/06/24.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var keyword = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func fetchData() {
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id) { (result) in
                self.user = result
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        if let key = UserDefaults.standard.value(forKey: "keyword"){
            keyword = key as! [String]
        }else {
            keyword = []
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "プロフィール"
        }else if section == 1{
            return "回答科目"
        }else{
            return ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                cell.textLabel?.text = user?.name
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
                cell.userImageView.image = user?.profilePic
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath)
                return cell
            }
            
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath)
            cell.textLabel?.text = "回答科目"
            if keyword.count == 0{
                cell.detailTextLabel?.text = "回答科目を決めましょう"
            }else if keyword.count == 1{
                cell.detailTextLabel?.text = keyword[0]
            }else {
                cell.detailTextLabel?.text = "複数選択済み"
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1{
            return 85
        }else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "selectKeywordSegue", sender: nil)
        }
    }
    
    

}
