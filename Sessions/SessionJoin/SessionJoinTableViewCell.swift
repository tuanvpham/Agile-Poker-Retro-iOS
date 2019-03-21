//
//  SessionJoinTableViewCell.swift
//  ACC
//
//  Created by Leonardo Araque on 1/27/19.
//  Copyright © 2019 Leonardo Araque. All rights reserved.
//

import UIKit

protocol SessionJoinTableViewCellDelegate {
    func didJoin(session: Models.session)
}

class SessionJoinTableViewCell: UITableViewCell {

    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var sessionType: UILabel!
    @IBOutlet weak var sessionOwner: UILabel!
    var sessionRef: Models.session = Models.session()
    //@IBOutlet weak var join: UIButton!
    
    @IBAction func join(_ sender: UIButton) {
        sessionRef.title = sessionName.text!
        sessionRef.session_type = sessionType.text!
        sessionRef.owner_username = sessionOwner.text!
        delegate?.didJoin(session: sessionRef)
    }
    
    var delegate: SessionJoinTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    

}
