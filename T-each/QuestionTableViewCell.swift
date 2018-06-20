//
//  QuestionTableViewCell.swift
//  T-each
//
//  Created by hiro on 2018/06/20.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var isAnsweredLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
