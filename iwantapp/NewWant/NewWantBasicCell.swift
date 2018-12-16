//
//  NewWantBasicCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 22.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class NewWantBasicCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    var wantActivity:WantActivity!
    var isWantText:Bool = false
    var isAnyThingText:Bool = false
    var controller:NewWantController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.returnKeyType = .done
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let str = textField.text{
            countLabel.text =  (String(describing: str.characters.count) + " / 64")
        }
        
        if isWantText == true{
            wantActivity.want = textField.text!
        }
        else if isAnyThingText == true{
            wantActivity.descript = textField.text!
        }
        controller.checkSubmitButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.characters.count <= 64
    }

}
