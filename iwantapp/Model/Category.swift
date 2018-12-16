//
//  Category.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 16.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import Foundation
import UIKit

class Category {
    var name: String!
    var image: UIImage!
    var color: UIColor!
    var w_image: UIImage!
    var c_image: UIImage!
    
    init(name:String, image:UIImage, w_image:UIImage, c_image:UIImage, color:UIColor) {
        self.name = name
        self.image = image
        self.w_image = w_image
        self.c_image = c_image
        self.color = color
    }
}
