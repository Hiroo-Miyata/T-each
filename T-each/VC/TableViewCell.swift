//
//  TableViewCell.swift
//  T-each
//
//  Created by hiro on 2018/06/24.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var introTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: RoundedImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var isAnsweredLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.marginView.layer.cornerRadius = 10
        self.categoryLabel.layer.cornerRadius = 10
        self.categoryLabel.clipsToBounds = true
        self.questionImageView.layer.cornerRadius = 5
        self.questionImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


