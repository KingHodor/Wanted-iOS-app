//
//  SettingsLocationCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 3.12.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class SettingsLocationCell: UITableViewCell {

    @IBOutlet weak var locationButton: UIButton!
    var viewController : SettingsController! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func handleLocationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup =  storyboard.instantiateViewController(withIdentifier: "SelectCityController") as? SelectCityController
        
        popup?.modalPresentationStyle = .currentContext
        popup?.modalTransitionStyle = .coverVertical
        popup?.selectLocationDelegate = viewController
        viewController.present(popup!, animated:true, completion: nil)
    }
}
