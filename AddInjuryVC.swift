//
//  AddInjuryVC.swift
//  Less is more
//
//  Created by Piotr Olejnik on 20.05.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//

import UIKit

protocol AddInjuryDelegate {
    func didAddNewInjury()
}

class AddInjuryVC: UIViewController {
    
    
    @IBOutlet weak var dismiss: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }

    @IBAction func dismissPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
  
}