//
//  SearchKeywordData.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 6.12.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import Foundation

class SearchKeywordData: NSObject {
    public var keywords:[SearchKeyword] = []
    public static let sharedInstance = SearchKeywordData()
    
    public func fillSearchList(){
       GET.sharedInstance.callSearchKeywords(responseToKeywords)
    }
    
    
    fileprivate func responseToKeywords(_ data:Data?){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                var keywords = json["result"].arrayValue
                if keywords.count > 0{
                    SearchKeywordData.sharedInstance.keywords.removeAll()
                    for i in (0 ..< keywords.count){
                        
                        let category = keywords[i]["category"].intValue
                        let keyword = keywords[i]["keyword"].stringValue
                        if category > 0 && category < 20{
                            let item = SearchKeyword()
                            item.category = category
                            item.keyword = keyword
                            SearchKeywordData.sharedInstance.keywords.append(item)
                        }
                    }
                }
                
            }
            else{
                DispatchQueue.main.async(execute: {
                    GET.sharedInstance.callSearchKeywords(self.responseToKeywords)
                })
            }
        } catch {
            DispatchQueue.main.async(execute: {
                GET.sharedInstance.callSearchKeywords(self.responseToKeywords)
            })
        }
    }
}
