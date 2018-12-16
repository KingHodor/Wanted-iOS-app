//
//  WantAmplitude.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 11.12.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import Foundation
import Amplitude_iOS


class WantAmplitude {
    
    static let sharedInstance = WantAmplitude()
    
    func  exception_event(exception:String){
        var problem=[String:String]()
        problem  = ["problem":exception]
        Amplitude.instance().logEvent("exception", withEventProperties: problem)
    }
    
    func  log_event(log:String){
        var problem=[String:String]()
        problem  = ["log":log]
        Amplitude.instance().logEvent("status", withEventProperties: problem)
    }
}
