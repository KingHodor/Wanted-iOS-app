//
//  FilterData.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 27.11.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

struct defaultsFilterKeys {
    static let keyMinPrice = "FilterMinPrice"
    static let keyMaxPrice = "FilterMaxPrice"
    static let keyDateOption = "FilterDateOption"
    static let keyCountry = "FilterCountry"
    static let keyCity = "FilterCity"
}

class FilterData: NSObject {
    
    public static let sharedInstance = FilterData()
    var categories:[Bool] = []
    var minPrice:Double = 0.0
    var maxPrice:Double = 1000000.0
    var dateOption:Int = 4  //1:Last 24 hours, 2:Last 7 days, 3:Last 1 month, 4:Show all wanteds
    var country:String!
    var city:String!
    var initialize:Bool = false
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        
        self.minPrice =  (decoder.decodeDouble(forKey: defaultsFilterKeys.keyMinPrice))
        self.maxPrice =  (decoder.decodeDouble(forKey: defaultsFilterKeys.keyMaxPrice))
        if let city =  (decoder.decodeObject(forKey: defaultsFilterKeys.keyCity) as? String){
            self.city = city
        }
        if let country =  (decoder.decodeObject(forKey: defaultsFilterKeys.keyCountry) as? String){
            self.country = country
        }
        
        self.dateOption =  (decoder.decodeInteger(forKey: defaultsFilterKeys.keyDateOption))
    }
    
    func encode(with decoder: NSCoder) {
        decoder.encode(minPrice, forKey: defaultsFilterKeys.keyMinPrice)
        decoder.encode(maxPrice, forKey: defaultsFilterKeys.keyMaxPrice)
        if let city = city { decoder.encode(city, forKey: defaultsFilterKeys.keyCity) }
        if let country = country { decoder.encode(country, forKey: defaultsFilterKeys.keyCountry) }
        decoder.encode(dateOption, forKey: defaultsFilterKeys.keyDateOption)
    }
    
    public func saveFilterData()
    {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(minPrice, forKey: defaultsFilterKeys.keyMinPrice)
        userDefaults.set(maxPrice, forKey: defaultsFilterKeys.keyMaxPrice)
        userDefaults.set(dateOption, forKey: defaultsFilterKeys.keyDateOption)
        userDefaults.set(country, forKey: defaultsFilterKeys.keyCountry)
        userDefaults.set(city, forKey: defaultsFilterKeys.keyCity)
        userDefaults.synchronize()
    }
}
