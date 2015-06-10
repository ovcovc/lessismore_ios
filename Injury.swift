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
    var pauseLength: String = ""
    var exercises: NSMutableArray = NSMutableArray()
    var points: Int = 0
    var urls: NSMutableArray = NSMutableArray()
    
}