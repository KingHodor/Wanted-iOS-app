//
//  SettingsContactCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 25.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class SettingsContactCell: UITableViewCell {

    @IBOutlet weak var phoneButton: UISwitch!
    @IBOutlet weak var emailButton: UISwitch!
    var controller:SettingsController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func handleEmailButton(_ sender: UISwitch) {
        if sender.isOn  {
            controller.tempUser.emailPrefer = true
        }
        else{
            controller.tempUser.emailPrefer = false
        }
   
    }
    
    @IBAction func handlePhoneButton(_ sender: UISwitch) {
        if sender.isOn  {
            controller.tempUser.phonePrefer = true
        }
        else{
            controller.tempUser.phonePrefer = false
        }
    }
    
}
