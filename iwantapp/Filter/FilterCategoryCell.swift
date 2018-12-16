//
//  FilterCategoryCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 3.12.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class FilterCategoryCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    var controller:FilterViewController!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCategoryButton))
        
        cellView.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc private func handleCategoryButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup =  storyboard.instantiateViewController(withIdentifier: "MultipleCategoryController") as? MultipleCategoryController
        
        popup?.modalPresentationStyle = .currentContext
        popup?.modalTransitionStyle = .coverVertical
        popup?.selectCategoryDelegate = controller
        popup?.categories = controller.tempFilterData.categories
        controller.present(popup!, animated:true, completion: nil)
    }
}
