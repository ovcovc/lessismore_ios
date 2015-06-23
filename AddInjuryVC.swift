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
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dismiss: UIButton!
    @IBOutlet weak var recoveryField: UITextField!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var medicationField: UITextView!
    @IBOutlet weak var exercisesField: UITextView!
    @IBOutlet weak var descField: UITextView!
    
    var position : NormalizedPosition? = nil
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    override func viewDidLoad(){
        super.viewDidLoad()
        self.activitySpinner.hidden = true
    }

    @IBAction func dismissPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func photoButtonTapped(sender: AnyObject) {
    }
    @IBAction func saveTapped(sender: AnyObject) {
        self.postInjury()
    }
    
    func postInjury(){
        self.activitySpinner.hidden = false
        var dict = NSMutableDictionary()
        dict["name"] = self.nameField.text
        dict["description"] = self.descField.text
        dict["x_axis"] = self.position?.x
        dict["y_axis"] = self.position?.y
        dict["exercises"] = self.exercisesField.text
        dict["medication"] = self.medicationField.text
        dict["treatments"] = "brak"
        dict["recovery_time"] = self.recoveryField.text
        
        let url = NSURL(string: "http://lit-wave-9027.herokuapp.com/injuries/") //change the url
        
        //create the session object
        var session = NSURLSession.sharedSession()
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST" //set http method as POST
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(dict, options: nil, error: &err) // pass dictionary to nsdata object and set it as request body
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //All stuff here
        })
        
        //create dataTask using the session object to send data to the server
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                println("Response: \(response)")
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Body: \(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                let httpResponse = response as! NSHTTPURLResponse
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: '\(jsonStr)'")
                }
                else {
                    var alert : UIAlertController
                    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
                    if iOS8 {
                        if httpResponse.statusCode == 201 {
                            alert = UIAlertController(title: "Excellent!", message: "Your injury has been sent!", preferredStyle: UIAlertControllerStyle.Alert)
                            print ("PEŁEN SUKCES")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            alert = UIAlertController(title: "Ooops!", message: "Your injury has not been sent succesfuly!", preferredStyle: UIAlertControllerStyle.Alert)
                        }
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertView()
                        if httpResponse.statusCode == 201 {
                            alert.title = "Excellent!"
                            alert.message = "Your injury has been sent!"
                            print ("PEŁEN SUKCES")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            alert.title = "Ooops!"
                            alert.message = "Your injury has not been sent succesfuly!"
                        }
                        alert.addButtonWithTitle("Click")
                        alert.show()
                    }
                }
                
                self.activitySpinner.hidden = true
            }
        })
        task.resume()
    }
}