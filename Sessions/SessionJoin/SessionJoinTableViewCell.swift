//
//  SessionJoinTableViewCell.swift
//  ACC
//
//  Created by Leonardo Araque on 1/27/19.
//  Copyright © 2019 Leonardo Araque. All rights reserved.
//

import UIKit

class SessionJoinTableViewCell: UITableViewCell {

    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var sessionType: UILabel!
    @IBOutlet weak var sessionOwner: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
