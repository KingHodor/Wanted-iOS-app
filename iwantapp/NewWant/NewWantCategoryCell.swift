//
//  NewWantCategoryCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 22.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class NewWantCategoryCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var openViewButton: UIButton!
    var viewController : NewWantController! = nil
    var type:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func handleOpenViewButton(_ sender: Any) {
        if type == "location"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let popup =  storyboard.instantiateViewController(withIdentifier: "SelectCityController") as? SelectCityController
            
            popup?.modalPresentationStyle = .currentContext
            popup?.modalTransitionStyle = .coverVertical
            popup?.selectLocationDelegate = viewController
            viewController.present(popup!, animated:true, completion: nil)
        }else if type == "category"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let popup =  storyboard.instantiateViewController(withIdentifier: "SelectCategoryController") as? SelectCategoryController
            
            popup?.modalPresentationStyle = .currentContext
            popup?.modalTransitionStyle = .coverVertical
            popup?.selectCategoryDelegate = viewController
            viewController.present(popup!, animated:true, completion: nil)
        }
        
    }
}
