//
//  Injury.swift
//  Less is more
//
//  Created by Piotr Olejnik on 10.06.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//

import UIKit

class Injury {
    
    var coordinates: NormalizedPosition = NormalizedPosition()
    var name: String = ""
    var description: String = ""
    var recoveryPeriod: String = ""
    var exercises: String = ""
    var points: Int = 0
    var urls: NSMutableArray = NSMutableArray()
    var medication: String = ""
    var treatment: String = ""
    
    init(){
        
    }
    
    init(dict: NSDictionary){
        self.description = dict["description"] as! String
        self.name = dict["name"] as! String
        self.coordinates.x = dict["x_axis"] as! CGFloat
        self.coordinates.y = dict["y_axis"] as! CGFloat
        self.recoveryPeriod = dict["recovery_time"] as! String
        self.exercises = dict["exercises"] as! String
        self.medication = dict["medication"] as! String
        self.treatment = dict["treatments"] as! String
    }
}