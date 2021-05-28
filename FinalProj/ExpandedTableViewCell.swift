//
//  ExpandedTableViewCell.swift
//  FinalProj
//
//  Created by Jason Talpalar on 4/2/21.
//

import UIKit

class ExpandedTableViewCell: UITableViewCell {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
