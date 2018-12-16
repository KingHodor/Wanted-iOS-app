//
//  FilterDateCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 26.11.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class FilterDateCell: UITableViewCell {

    @IBOutlet weak var allTick: UIImageView!
    @IBOutlet weak var monthTick: UIImageView!
    @IBOutlet weak var weekTick: UIImageView!
    @IBOutlet weak var dayTick: UIImageView!
    var controller:FilterViewController!
   
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    
    @IBOutlet weak var allButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func initTableCell(){
        if controller.tempFilterData.dateOption == 1 {
            dayTick.isHidden = false
            weekTick.isHidden = true
            monthTick.isHidden = true
            allTick.isHidden = true
            dayButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
            weekButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            monthButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            allButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        }else if controller.tempFilterData.dateOption == 2 {
            dayTick.isHidden = true
            weekTick.isHidden = false
            monthTick.isHidden = true
            allTick.isHidden = true
            weekButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
            dayButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            monthButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            allButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        }
        else if controller.tempFilterData.dateOption == 3 {
            dayTick.isHidden = true
            weekTick.isHidden = true
            monthTick.isHidden = false
            allTick.isHidden = true
            monthButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
            dayButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            weekButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            allButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        }
        else if controller.tempFilterData.dateOption == 4 {
            dayTick.isHidden = true
            weekTick.isHidden = true
            monthTick.isHidden = true
            allTick.isHidden = false
            allButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
            dayButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            weekButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
            monthButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        }
    }

    @IBAction func handleLastDay(_ sender: Any) {
        controller.tempFilterData.dateOption = 1
        dayTick.isHidden = false
        weekTick.isHidden = true
        monthTick.isHidden = true
        allTick.isHidden = true
        dayButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
        weekButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        monthButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        allButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
    }
    
    @IBAction func handleLastWeek(_ sender: Any) {
        controller.tempFilterData.dateOption = 2
        dayTick.isHidden = true
        weekTick.isHidden = false
        monthTick.isHidden = true
        allTick.isHidden = true
        weekButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
        dayButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        monthButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        allButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
    }
    
    @IBAction func handleLastMonth(_ sender: Any) {
        controller.tempFilterData.dateOption = 3
        dayTick.isHidden = true
        weekTick.isHidden = true
        monthTick.isHidden = false
        allTick.isHidden = true
        monthButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
        dayButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        weekButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        allButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
    }
    
    @IBAction func handleAll(_ sender: Any) {
        controller.tempFilterData.dateOption = 4
        dayTick.isHidden = true
        weekTick.isHidden = true
        monthTick.isHidden = true
        allTick.isHidden = false
        allButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: .normal)
        dayButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        weekButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
        monthButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
    }
}
