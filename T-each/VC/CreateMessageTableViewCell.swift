//
//  CreateMessageTableViewCell.swift
//  T-each
//
//  Created by hiro on 2018/06/24.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit

class CreateMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var messageImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
