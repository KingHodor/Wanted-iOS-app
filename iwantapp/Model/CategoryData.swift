//
//  CategoryData.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 16.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import Foundation
import UIKit

class CategoryData: NSObject {
    
    public static let sharedInstance = CategoryData()
    
    public var categoryList:Dictionary<Int, Category> = Dictionary<Int, Category>()
    let redPink = UIColor(red: 235/255, green: 68/255, blue: 71/255, alpha: 1)
    let squash = UIColor(red: 236/255, green: 154/255, blue: 35/255, alpha: 1)
    let tealish = UIColor(red: 49/255, green: 173/255, blue: 204/255, alpha: 1)
    let paleOliveGreen = UIColor(red: 168/255, green: 211/255, blue: 86/255, alpha: 1)
    let flatBlue = UIColor(red: 54/255, green: 119/255, blue: 169/255, alpha: 1)
    
    override init(){
        categoryList[1] = Category(name: "Cars", image: #imageLiteral(resourceName: "c_cars"), w_image: #imageLiteral(resourceName: "w_cars"), c_image: #imageLiteral(resourceName: "r_cars"), color: redPink)
        categoryList[2] = Category(name: "Tech", image: #imageLiteral(resourceName: "c_tech"), w_image: #imageLiteral(resourceName: "w_tech"), c_image: #imageLiteral(resourceName: "r_tech"), color: squash)
        categoryList[3] = Category(name: "Home", image: #imageLiteral(resourceName: "c_home"), w_image: #imageLiteral(resourceName: "w_home"), c_image: #imageLiteral(resourceName: "r_home"), color: tealish)
        categoryList[4] = Category(name: "Book", image: #imageLiteral(resourceName: "c_books"), w_image: #imageLiteral(resourceName: "w_books"), c_image: #imageLiteral(resourceName: "r_books"), color: paleOliveGreen)
        categoryList[5] = Category(name: "Leisure & Entertainment", image: #imageLiteral(resourceName: "c_leisure"), w_image: #imageLiteral(resourceName: "w_leisure"), c_image: #imageLiteral(resourceName: "r_leisure"), color: flatBlue)
        categoryList[6] = Category(name: "Transportation", image: #imageLiteral(resourceName: "c_transportation"), w_image: #imageLiteral(resourceName: "w_transportation"), c_image: #imageLiteral(resourceName: "r_transportation"), color: redPink)
        categoryList[7] = Category(name: "Clothing", image: #imageLiteral(resourceName: "c_clothing"), w_image: #imageLiteral(resourceName: "w_clothing"), c_image: #imageLiteral(resourceName: "r_clothing"), color: squash)
        categoryList[8] = Category(name: "Child", image: #imageLiteral(resourceName: "c_child"), w_image: #imageLiteral(resourceName: "w_child"), c_image: #imageLiteral(resourceName: "r_child"), color: tealish)
        categoryList[9] = Category(name: "Health", image: #imageLiteral(resourceName: "c_health"), w_image: #imageLiteral(resourceName: "w_health"), c_image: #imageLiteral(resourceName: "r_health"), color: paleOliveGreen)
        categoryList[10] = Category(name: "Sports & Fitness", image: #imageLiteral(resourceName: "c_sports"), w_image: #imageLiteral(resourceName: "w_sports"), c_image: #imageLiteral(resourceName: "r_sports"), color: flatBlue)
        categoryList[11] = Category(name: "Volunteer", image: #imageLiteral(resourceName: "c_volunteer"), w_image: #imageLiteral(resourceName: "w_volunteer"), c_image: #imageLiteral(resourceName: "r_volunteer"), color: redPink)
        categoryList[12] = Category(name: "Shopping", image: #imageLiteral(resourceName: "c_shopping"), w_image: #imageLiteral(resourceName: "w_shopping"), c_image: #imageLiteral(resourceName: "r_shopping"), color: squash)
        categoryList[13] = Category(name: "Delivery", image: #imageLiteral(resourceName: "c_delivery"), w_image: #imageLiteral(resourceName: "w_delivery"), c_image: #imageLiteral(resourceName: "r_delivery"), color: tealish)
        categoryList[14] = Category(name: "Seasonal", image: #imageLiteral(resourceName: "c_seasonal"), w_image: #imageLiteral(resourceName: "w_seasonal"), c_image: #imageLiteral(resourceName: "r_seasonal"), color: paleOliveGreen)
        categoryList[15] = Category(name: "Photography &Video", image: #imageLiteral(resourceName: "c_photography"), w_image: #imageLiteral(resourceName: "w_photography"), c_image: #imageLiteral(resourceName: "r_photography"), color: flatBlue)
        categoryList[16] = Category(name: "Petcare", image: #imageLiteral(resourceName: "c_petcare"), w_image: #imageLiteral(resourceName: "w_petcare"), c_image: #imageLiteral(resourceName: "r_petcare"), color: redPink)
        categoryList[17] = Category(name: "Lessons & Tutoring", image: #imageLiteral(resourceName: "c_tutor"), w_image: #imageLiteral(resourceName: "w_tutor"), c_image: #imageLiteral(resourceName: "r_tutor"), color: squash)
        categoryList[18] = Category(name: "Business", image: #imageLiteral(resourceName: "c_business"), w_image: #imageLiteral(resourceName: "w_business"), c_image: #imageLiteral(resourceName: "r_business"), color: tealish)
        categoryList[19] = Category(name: "Handyman", image: #imageLiteral(resourceName: "c_handyman"), w_image: #imageLiteral(resourceName: "w_handyman"), c_image: #imageLiteral(resourceName: "r_handyman"), color: paleOliveGreen)
        categoryList[20] = Category(name: "Other", image: #imageLiteral(resourceName: "c_other"), w_image: #imageLiteral(resourceName: "w_other"), c_image: #imageLiteral(resourceName: "r_other"), color: flatBlue)
    }
}
