//
//  ViewController.swift
//  Less is more
//
//  Created by Piotr Olejnik on 08.05.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    class NormalizedPosition {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
    }
    
    class DenormalizedPosition {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
    }
    
    class Injury {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
    }
    
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!

    func addMarker(x: CGFloat, y: CGFloat){
        let testFrame : CGRect = CGRectMake(x-25,y-25,50,50)
        var testView : UIView = UIView(frame: testFrame)
        testView.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.2, alpha: 1.0)
        testView.alpha=0.8
        self.view.addSubview(testView)
    }
    
    func addInjuryMarkers() {
        //Method to add all the markers, based on current scale and scroll
    }
    
    func clearSubviews() {
        //remove all the markers in order to redraw them
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        scroll.maximumZoomScale=5;
        scroll.minimumZoomScale=1;
        scroll.bounces=true;
        scroll.bouncesZoom=true;
        scroll.contentSize=CGSizeMake(image.frame.size.width, image.frame.size.height);
        scroll.showsHorizontalScrollIndicator=true;
        scroll.showsVerticalScrollIndicator=true;
        scroll.delegate=self;//assigning delegate
        // Do any additional setup after loading the view, typically from a nib.
        var imageView = UIImageView(frame: CGRectMake(0,0,self.view.frame.width,20))
        let screenImage = getImageWithColor(UIColor.clearColor(), size: CGSize(width: 100, height: 100))
        imageView.image = screenImage
        self.view.addSubview(imageView)
        self.addMarker(100, y:100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    @IBAction func longPressDetected(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began){
            let x = sender.locationInView(self.view).x / self.scroll.zoomScale
            let y = sender.locationInView(self.view).y / self.scroll.zoomScale
            self.addInjury(sender.locationInView(self.view).x,y: sender.locationInView(self.view).y)
            self.addMarker(x, y:y)
        }
    }
    
    func denormalizePosition(x: CGFloat, y:CGFloat) -> DenormalizedPosition {
        var denormPos = DenormalizedPosition()
        denormPos.x = x * self.scroll.zoomScale
        denormPos.y = y * self.scroll.zoomScale
        return denormPos
    }
    
    func getNormalizedPosition(x: CGFloat, y:CGFloat) -> NormalizedPosition{
        var normPos = NormalizedPosition()
        normPos.x = x / self.image.frame.width
        normPos.y = y / self.image.frame.height
        return normPos
    }
    
    func addInjury(x: CGFloat, y: CGFloat) {
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ContextualMenu") as! UIViewController
        var nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(150,150)
        //popover.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(x,y,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.image
    }
}
    


