//
//  IconView.swift
//  Less is more
//
//  Created by Piotr Olejnik on 07.06.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//

import UIKit

protocol IconViewDelegate {
    func didPressIcon(icon: IconView)
}

@IBDesignable class IconView : UIView {
    

    @IBOutlet weak var back: UIImageView!
    var view: UIView!
    var delegate : IconViewDelegate? = nil
    var pxX : Int = 0
    var pxY : Int = 0
    var injuries : NSMutableArray = NSMutableArray ()
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override init(frame : CGRect){
        super.init(frame: frame)
        self.xibSetup()
    }

    init(frame: CGRect, number: Int, pxx: Int, pxy: Int, injury: Injury){
        super.init(frame: frame)
        self.xibSetup()
        self.pxX = pxx
        self.pxY = pxy
        self.injuries.addObject(injury)
        if number == 1 {
            self.number.hidden = true
        } else {
            self.number.hidden = false
        }
        self.number.text = "\(number)"
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        self.delegate?.didPressIcon(self)
    }
    
    func setDelegate(delegate: IconViewDelegate) {
        self.delegate = delegate
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
        let view:UIView = NSBundle.mainBundle().loadNibNamed("IconView", owner: self, options: nil).first as! UIView
        return view
    }
}
