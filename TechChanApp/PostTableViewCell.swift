//
//  PostTableViewCell.swift
//  TechChanApp
//
//  Created by Haruko Okada on 9/23/20.
//  Copyright © 2020 Haruko Okada. All rights reserved.
//

import UIKit

//セルのクラス
class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
