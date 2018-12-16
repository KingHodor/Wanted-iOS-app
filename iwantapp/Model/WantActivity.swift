//
//  WantActivity.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 19.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//
//
//String want;
//int category;
//String phone;
//String email;
//BigDecimal minPrice;
//BigDecimal maxPrice;
//String description;
//String latitude;
//String longitude;
//String city;
//String country;

import Foundation

struct defaultsWantKeys {
    static let keyWantId = "wantId"
    static let keyWant = "wantWant"
    static let keyWantCategory = "wantCategory"
    static let keyPhone = "wantPhone"
    static let keyEmail = "wantEmail"
    static let keyMinPrice = "wantMinPrice"
    static let keyMaxPrice = "wantMaxPrice"
    static let keyCity = "wantCity"
    static let keyCountry = "wantCountry"
    static let keyCurrency = "wantCurrency"
    static let keyDescription = "wantDescription"
    static let keyLatitude = "wantLatitude"
    static let keyLongitude = "wantLongitude"
    static let keyEmailPrefer = "emailPrefer"
    static let keyPhonePrefer = "phonePrefer"
}

class WantActivity: NSObject, NSCoding {
    var id:Int64!
    var want: String!
    var category:Int!
    var phone: String!
    var email: String!
    var minPrice:Double!
    var maxPrice:Double!
    var city:String!
    var country:String!
    var currency:String!
    var descript:String!
    var latitude:Float!
    var longitude:Float!
    var emailPrefer:Int!
    var phonePrefer:Int!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        if let want =  (decoder.decodeObject(forKey: defaultsWantKeys.keyWant) as? String){
            self.want = want
        }
        self.category =  (decoder.decodeInteger(forKey: defaultsWantKeys.keyWantCategory))
        if let phone =  (decoder.decodeObject(forKey: defaultsWantKeys.keyPhone) as? String){
            self.phone = phone
        }
        if let email =  (decoder.decodeObject(forKey: defaultsWantKeys.keyEmail) as? String){
            self.email = email
        }
        self.minPrice =  (decoder.decodeDouble(forKey: defaultsWantKeys.keyMinPrice))
        self.maxPrice =  (decoder.decodeDouble(forKey: defaultsWantKeys.keyMaxPrice))
        if let city =  (decoder.decodeObject(forKey: defaultsWantKeys.keyCity) as? String){
            self.city = city
        }
        if let country =  (decoder.decodeObject(forKey: defaultsWantKeys.keyCountry) as? String){
            self.country = country
        }
        if let currency =  (decoder.decodeObject(forKey: defaultsWantKeys.keyCurrency) as? String){
            self.currency = currency
        }
        if let descript =  (decoder.decodeObject(forKey: defaultsWantKeys.keyDescription) as? String){
            self.descript = descript
        }
        self.id =  (decoder.decodeInt64(forKey: defaultsWantKeys.keyWantId))
        self.latitude =  (decoder.decodeFloat(forKey: defaultsWantKeys.keyLatitude))
        self.longitude =  (decoder.decodeFloat(forKey: defaultsWantKeys.keyLongitude))
        self.emailPrefer =  (decoder.decodeInteger(forKey: defaultsWantKeys.keyEmailPrefer))
        self.phonePrefer =  (decoder.decodeInteger(forKey: defaultsWantKeys.keyPhonePrefer))
    }
    
    convenience init(want:String?, category:Int?, phone:String?, email:String?, minPrice:Double?, maxPrice:Double?, city:String?, country:String?, currency:String?, description:String?, emailPrefer:Int?, phonePrefer:Int?) {
        self.init()
        self.want = want
        self.category = category
        self.phone = phone
        self.email = email
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.city = city
        self.country = country
        self.descript = description
        self.currency = currency
        self.emailPrefer = emailPrefer
        self.phonePrefer = phonePrefer
    }
    
    func encode(with decoder: NSCoder) {
        if let want = want { decoder.encode(want, forKey: defaultsWantKeys.keyWant) }
        if let category = category { decoder.encode(category, forKey: defaultsWantKeys.keyWantCategory) }
        if let phone = phone { decoder.encode(phone, forKey: defaultsWantKeys.keyPhone) }
        if let email = email { decoder.encode(email, forKey: defaultsWantKeys.keyEmail) }
        if let minPrice = minPrice { decoder.encode(minPrice, forKey: defaultsWantKeys.keyMinPrice) }
        if let maxPrice = maxPrice { decoder.encode(maxPrice, forKey: defaultsWantKeys.keyMaxPrice) }
        if let city = city { decoder.encode(city, forKey: defaultsWantKeys.keyCity) }
        if let country = country { decoder.encode(country, forKey: defaultsWantKeys.keyCountry) }
        if let descript = descript { decoder.encode(descript, forKey: defaultsWantKeys.keyDescription) }
        if let currency = currency { decoder.encode(currency, forKey: defaultsWantKeys.keyCurrency) }
        if let id = id { decoder.encode(id, forKey: defaultsWantKeys.keyWantId) }
        if let emailPrefer = emailPrefer { decoder.encode(emailPrefer, forKey: defaultsWantKeys.keyEmailPrefer) }
        if let phonePrefer = phonePrefer { decoder.encode(phonePrefer, forKey: defaultsWantKeys.keyPhonePrefer) }
    }
    
    func wantCopy() -> WantActivity {
        let copy = WantActivity(want: want, category:category, phone:phone, email:email, minPrice:minPrice, maxPrice:maxPrice, city:city, country:country, currency:currency, description:descript, emailPrefer:emailPrefer, phonePrefer:phonePrefer)
        copy.id = id
        return copy
    }
}
