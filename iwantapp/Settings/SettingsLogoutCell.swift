//
//  SettingsLogoutCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 25.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class SettingsLogoutCell: UITableViewCell {

    var settingsController:SettingsController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func handleLogoutButton(_ sender: Any) {
        settingsController.openLogoutPopup()
    }
}
