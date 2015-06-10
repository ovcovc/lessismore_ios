//
//  PopoverVC.swift
//  Less is more
//
//  Created by Piotr Olejnik on 20.05.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//
import UIKit

protocol ChooseInjuryDelegate {
    
    func didChooseInjuryToShow(injury: Injury)
    
}

class ChooseInjuryVC: UITableViewController {
    
    var injuries: NSMutableArray = NSMutableArray ()
    var delegate : ChooseInjuryDelegate? = nil
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.injuries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("injuryCell", forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = (injuries[row] as! Injury).name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.delegate!.didChooseInjuryToShow(self.injuries[indexPath.row] as! Injury)
        })
    }
}