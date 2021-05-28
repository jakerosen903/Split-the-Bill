//
//  DefaultTableViewCell.swift
//  FinalProj
//
//  Created by Jason Talpalar on 4/2/21.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var guestTotalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
