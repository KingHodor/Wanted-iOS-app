//
//  SettingsWantCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 25.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class SettingsWantCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var wantText: UILabel!
    private var editWantMenu:CNPPopupController?
    public var controller:SettingsController!
    public var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func handleEditButton(_ sender: Any) {
        let width = UIApplication.shared.keyWindow?.bounds.width
        
        let editButton = CNPPopupButton.init(frame: CGRect(x: 0, y: 0, width: width!, height: 48))
        editButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: UIControlState())
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        editButton.setTitle("Edit", for: UIControlState())
        editButton.selectionHandler = { (button) -> Void in
            self.controller.editActivity(indexPath: self.indexPath)
            self.editWantMenu?.dismiss(animated: true)
        }
        
        let removeButton = CNPPopupButton.init(frame: CGRect(x: 0, y: 0, width: width!, height: 64))
        removeButton.setTitleColor(UIColor(red: 66/255, green:66/255, blue: 66/255, alpha: 1), for: UIControlState())
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        removeButton.setTitle("Remove", for: UIControlState())
        removeButton.selectionHandler = { (button) -> Void in
            self.controller.deleteActivity(indexPath: self.indexPath)
            self.editWantMenu?.dismiss(animated: true)
        }
        
        let cancelButton = CNPPopupButton.init(frame: CGRect(x: 0, y: 0, width: width!, height: 64))
        cancelButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1), for: UIControlState())
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.setTitle("Cancel", for: UIControlState())
        cancelButton.selectionHandler = { (button) -> Void in
            self.editWantMenu?.dismiss(animated: true)
        }
        
        let popupController = CNPPopupController(contents:[editButton, removeButton, cancelButton])
        popupController.theme = CNPPopupTheme.default()
        
        
        popupController.theme.popupStyle = .actionSheet
        
        self.editWantMenu = popupController
        popupController.present(animated: true)
    }
}
