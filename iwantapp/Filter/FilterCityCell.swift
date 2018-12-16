//
//  FilterCityCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 26.11.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class FilterCityCell: UITableViewCell, SelectLocationDelegate {

    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellLabel: UILabel!
    var controller:FilterViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func handleButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup =  storyboard.instantiateViewController(withIdentifier: "SelectCityController") as? SelectCityController
        
        popup?.modalPresentationStyle = .currentContext
        popup?.modalTransitionStyle = .coverVertical
        popup?.selectLocationDelegate = self
        controller.present(popup!, animated:true, completion: nil)
    }
    
    func selectLocation(_ result: String){
        let results = result.components(separatedBy: ", ")
        let city = results[0]
        let country = results[results.count - 1]
        controller.tempFilterData.city = city
        controller.tempFilterData.country = country
        cellButton.setTitle(city + ", " +  country, for: UIControlState())
    }
}
