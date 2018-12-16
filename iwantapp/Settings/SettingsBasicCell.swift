//
//  SettingsBasicCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 25.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class SettingsBasicCell: UITableViewCell, UITextFieldDelegate{
    
    @IBOutlet weak var cellText: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    var isPhoneText:Bool = false
    var isEmailText:Bool = false
    var isNameText:Bool = false
    var controller:SettingsController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellText.returnKeyType = .done
        cellText.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func designCell(){
        if isPhoneText == true{
            cellText.keyboardType = UIKeyboardType.phonePad
        }
        
        if ((isEmailText == true) || (isNameText == true)){
            self.cellText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (isPhoneText == true){
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0{
               controller.tempUser.phone = ""
            }
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            let unformattedIndex = 0 as Int
            let unformattedString = NSMutableString()
            
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            unformattedString.append(decimalString.substring(from: unformattedIndex))
            textField.text = formattedString as String
            controller.tempUser.phone = unformattedString as String
            print(cellText.text!)
            print(controller.tempUser.phone)
            return false
        } else {
            return true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if isNameText == true{
           controller.tempUser.name = cellText.text!
        }else if isEmailText == true{
           controller.tempUser.email = cellText.text!
        }
    }
}

extension String.CharacterView {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
