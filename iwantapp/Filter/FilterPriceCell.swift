//
//  FilterPriceCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 26.11.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class FilterPriceCell: UITableViewCell, UITextFieldDelegate {

    var controller:FilterViewController!
    
    @IBOutlet weak var maxText: UITextField!
    @IBOutlet weak var minText: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        minText.returnKeyType = .done
        maxText.returnKeyType = .done
        minText.delegate = self
        maxText.delegate = self
        minText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        maxText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        minText.keyboardType = .decimalPad
        maxText.keyboardType = .decimalPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if textField == minText {
            if minText.text != ""{
                controller.tempFilterData.minPrice = Double(minText.text!)!
            }
            else{
                controller.tempFilterData.minPrice = 0.0
            }
            
        }else  if textField == maxText {
            if maxText.text != ""{
                 controller.tempFilterData.maxPrice = Double(maxText.text!)!
            }
            else{
                 controller.tempFilterData.maxPrice = 1000000.0
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let computationString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // Take number of digits present after the decimal point.
        let arrayOfSubStrings = computationString.components(separatedBy: ".")
        
        if arrayOfSubStrings.count == 1 && computationString.characters.count > Constants.MAX_BEFORE_DECIMAL_DIGITS {
            return false
        } else if arrayOfSubStrings.count == 2 {
            let stringPostDecimal = arrayOfSubStrings[1]
            return stringPostDecimal.characters.count <= Constants.MAX_AFTER_DECIMAL_DIGITS
        }
        
        return true
    }
    

}
