//
//  NoRecordCell.swift
//  Tyst
//
//  Created by hb on 03/03/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class NoRecordCell: UITableViewCell {

    static let cellId = "NoRecordCell"
    
    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
