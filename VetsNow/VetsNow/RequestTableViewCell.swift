//
//  RequestTableViewCell.swift
//  VetsNow
//
//  Created by Admin on 10/14/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var userRequest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
