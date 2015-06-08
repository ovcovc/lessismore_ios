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
        var coordinates: NormalizedPosition = NormalizedPosition()
    }
    
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!

    var injuries: NSMutableArray = NSMutableArray()
    
    func addMarker(x: CGFloat, y: CGFloat){
        var offset = self.scroll.contentOffset
        let testFrame : CGRect = CGRectMake(x-25,y-25,50.0,50.0)
        var iconView : IconView = IconView(frame: testFrame, number:1, scale:self.scroll.zoomScale)
        self.view.addSubview(iconView)
    }
    
    func addInjuryMarkers() {
        for injury in self.injuries {
            var denormXY = self.denormalizePosition((injury as! Injury).coordinates.x, y: (injury as! Injury).coordinates.y)
            self.addMarker(denormXY.x, y: denormXY.y)
        }
        //Method to add all the markers, based on current scale and scroll
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
        self.image.addSubview(imageView)
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
            var w = sender.locationInView(self.image).x
            var h = sender.locationInView(self.image).y
            self.addInjury(sender.locationInView(self.view).x,y: sender.locationInView(self.view).y, imageX: w, imageY: h)
        }
    }
    
    func denormalizePosition(x: CGFloat, y:CGFloat) -> DenormalizedPosition {
        var denormPos = DenormalizedPosition()
        var imageFrame : CGRect = self.image.frame
        var viewFrame : CGRect = self.view.frame
        var imageX : CGFloat = (self.image.image! as UIImage).size.width
        var imageY : CGFloat = (self.image.image! as UIImage).size.height
        var ratioX : CGFloat = imageX/self.view.frame.width
        var ratioY : CGFloat = imageY/self.view.frame.height
        var visibleRect: CGRect = self.scroll.convertRect(self.scroll.bounds, toView: self.image)
        denormPos.x = (x * self.image.frame.width / self.scroll.zoomScale - visibleRect.origin.x) * self.scroll.zoomScale //* ratioX
        denormPos.y = (y * self.image.frame.height / self.scroll.zoomScale - visibleRect.origin.y) * self.scroll.zoomScale //* ratioY
        return denormPos
    }
    
    func getNormalizedPosition(x: CGFloat, y:CGFloat) -> NormalizedPosition{
        var normPos = NormalizedPosition()
        normPos.x = self.scroll.zoomScale * x / self.image.frame.width
        normPos.y = self.scroll.zoomScale * y / self.image.frame.height
        return normPos
    }
    
    func addInjury(x: CGFloat, y: CGFloat, imageX: CGFloat, imageY: CGFloat) {
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ContextualMenu") as! UIViewController
        var nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(150,150)
        //popover.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(x,y,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
        var normXY = self.getNormalizedPosition(imageX, y: imageY)
        var injury = Injury()
        injury.coordinates = normXY
        injuries.addObject(injury)
        var denormXY = self.denormalizePosition(injury.coordinates.x, y: injury.coordinates.y)
        self.addMarker(denormXY.x, y: denormXY.y)
    }
    
    
    func removeInjuryMarkers() {
        for view in self.view.subviews {
            if view is IconView {
                print("h: \(view.frame.height) w: \(view.frame.width)")
                view.removeFromSuperview()
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        self.removeInjuryMarkers()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
            self.addInjuryMarkers()
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!){
        self.removeInjuryMarkers()
    }
    
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        
            self.addInjuryMarkers()
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.image
    }
}
    


