//
//  IconView.swift
//  Less is more
//
//  Created by Piotr Olejnik on 07.06.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//

import UIKit

@IBDesignable class IconView : UIView {
    
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var number: UILabel!
    var view: UIView!
    
    override init(frame : CGRect){
        super.init(frame: frame)
        self.xibSetup()
    }

    init(frame: CGRect, number: Int, scale: CGFloat){
        super.init(frame: frame)
        self.xibSetup()
        //self.number.text = "\(number)"
        self.layer.cornerRadius = 8.0/scale
        self.clipsToBounds = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        print("chybaty")
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "IconView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}
