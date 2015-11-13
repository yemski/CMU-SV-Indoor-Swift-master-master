//
//  LocationResultsCell.swift
//  CMU-SV-Indoor-Swift
//
//  Created by Jon Baron on 11/12/15.
//  Copyright © 2015 CMU-SV. All rights reserved.
//

import UIKit

class LocationResultsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buildingsAddressLabel: UILabel!
    @IBOutlet weak var floorNumberLabel: UILabel!
    @IBOutlet weak var roomCapacityLabel: UILabel!
    @IBOutlet weak var roomAvailabilityLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
