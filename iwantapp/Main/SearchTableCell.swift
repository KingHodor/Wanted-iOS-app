//
//  SearchTableCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 5.12.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {

    @IBOutlet weak var searchText: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
