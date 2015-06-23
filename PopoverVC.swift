//
//  PopoverVC.swift
//  Less is more
//
//  Created by Piotr Olejnik on 20.05.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//
import UIKit

class PopoverVC: UITableViewController {
    
    var position : NormalizedPosition? = nil
    
    let options = ["Add new injury", "Report abuse", "Dismiss"]
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addInjury" && self.position != nil {
            (segue.destinationViewController as! AddInjuryVC).position = self.position
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = options[row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        if (row == 0) {
            self.performSegueWithIdentifier("addInjury", sender: self)
        }
        else if (row == 2) {
            self.dismissViewControllerAnimated(true, completion: {});
        }
    }
}
