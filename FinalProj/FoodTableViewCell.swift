//
//  FoodTableViewCell.swift
//  FinalProj
//
//  Created by Jason Talpalar on 4/2/21.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var guests: UIImageView!
    @IBOutlet weak var proceed: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
