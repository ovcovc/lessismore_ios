//
//  DetailsVC.swift
//  Less is more
//
//  Created by Piotr Olejnik on 10.06.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//

import UIKit

class DetailsVC : UIViewController {
    
    @IBOutlet weak var medication: UITextView!
    @IBOutlet weak var exercises: UITextView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var treatment: UITextView!
    @IBOutlet weak var recoveryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var injury : Injury = Injury()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLabels()
    }
    
    func setupLabels() {
        self.medication.text = self.injury.medication
        self.nameLabel.text = self.injury.name
        self.exercises.text = self.injury.exercises
        self.treatment.text = self.injury.treatment
        self.recoveryLabel.text = self.injury.recoveryPeriod
        self.descText.text = self.injury.description
    }
}
