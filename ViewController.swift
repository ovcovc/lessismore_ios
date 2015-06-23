//
//  ViewController.swift
//  Less is more
//
//  Created by Piotr Olejnik on 08.05.2015.
//  Copyright (c) 2015 Piotr Olejnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, IconViewDelegate, ChooseInjuryDelegate, NSURLConnectionDelegate, ConnectionDelegate {
    
    let MAX_ZOOM_FACTOR : CGFloat = 7.0
    
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!

    var injuries: NSMutableArray = NSMutableArray()
    var drawnMarkers : Int = 0
    var selectedInjury : Injury = Injury()
    var data : NSMutableData = NSMutableData()
    var delegate: AppDelegate? = nil

    
    func getOverlappingIconOrCreate(frame: CGRect, number: Int, pxx: Int, pxy: Int, injury: Injury) -> IconView {
        for view in self.view.subviews {
            if view is IconView {
                if CGRectIntersectsRect(view.frame, frame){
                    var v = view as! IconView
                    var num : Int = v.number.text!.toInt()!
                    num += 1
                    v.number.text = "\(num)"
                    /*
                    //compute coordinates to place resulting view halfway between two points
                    let halfwayX = (view.frame.origin.x + frame.origin.x) / 2
                    let halfwayY = (view.frame.origin.y + frame.origin.y) / 2
                    v.frame.origin.x = halfwayX
                    v.frame.origin.y = halfwayY
                    */
                    v.injuries.addObject(injury)
                    v.number.hidden = false
                    return v
                }
            }
        }
        var icon : IconView = IconView(frame: frame, number: number, pxx: pxx, pxy: pxy, injury:injury)
        self.view.addSubview(icon)
        return icon
    }
    
    func addMarker(x: CGFloat, y: CGFloat, number: Int, pxx: Int, pxy: Int, injury: Injury){
        var offset = self.scroll.contentOffset
        let testFrame : CGRect = CGRectMake(x-25,y-25,50.0,50.0)
        var iconView : IconView = self.getOverlappingIconOrCreate(testFrame, number: number, pxx: pxx, pxy: pxy, injury: injury)
        iconView.setDelegate(self)
        iconView.setNeedsDisplay()
        self.drawnMarkers += 1
    }
    
    func addInjuryMarkers() {
        for injury in self.injuries {
            var x = (injury as! Injury).coordinates.x
            var y = (injury as! Injury).coordinates.y
            var denormXY = self.denormalizePosition(x, y: y)
            var bounds = self.view.bounds
            var fr = self.view.frame
            var pxx = Int(x * self.view.frame.width)
            var pxy = Int(y * self.view.frame.height)
            self.addMarker(denormXY.x, y: denormXY.y, number: 1, pxx: pxx, pxy: pxy, injury: injury as! Injury)
        }
        //Method to add all the markers, based on current scale and scroll
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        scroll.maximumZoomScale = MAX_ZOOM_FACTOR;
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
        self.delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.delegate?.connectionDelegate = self
        self.image.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            var tabBarVC = (segue.destinationViewController as! UITabBarController)
            var detailsVC = tabBarVC.viewControllers?.first as! DetailsVC
            detailsVC.injury = self.selectedInjury
        }
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
    
    func getModalPopover(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, popoverContent: UIViewController) -> UINavigationController {
        var nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(width,height)
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(x,y,0,0)
        return nav
    }
    
    func addContextualMenuPopover(x: CGFloat, y: CGFloat, position:NormalizedPosition){
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ContextualMenu") as! PopoverVC
        popoverContent.position = position
        let nav = self.getModalPopover(x, y: y, width: 150, height: 132, popoverContent: popoverContent) as UINavigationController
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func addInjuryNamesPopover(x: CGFloat, y: CGFloat, injuries: NSMutableArray) {
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ChooseInjuryMenu") as! ChooseInjuryVC
        popoverContent.injuries = injuries
        popoverContent.delegate = self
        let nav = self.getModalPopover(x, y: y, width: 250.0, height: CGFloat(44*injuries.count), popoverContent: popoverContent) as UINavigationController
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func addInjury(x: CGFloat, y: CGFloat, imageX: CGFloat, imageY: CGFloat) {
        var normXY = self.getNormalizedPosition(imageX, y: imageY)
        self.addContextualMenuPopover(x, y: y, position:normXY)
        /*
        var injury = Injury()
        injury.coordinates = normXY
        injury.name = "kontuzja"
        injuries.addObject(injury)
        var denormXY = self.denormalizePosition(injury.coordinates.x, y: injury.coordinates.y)
        var pxx = Int(injury.coordinates.x * self.view.frame.width)
        var pxy = Int(injury.coordinates.y * self.view.frame.height)
        self.addMarker(denormXY.x, y: denormXY.y, number: 1, pxx: pxx, pxy: pxy, injury: injury)
        */
    }
    
    
    func removeInjuryMarkers() {
        for view in self.view.subviews {
            if view is IconView {
                print("h: \(view.frame.height) w: \(view.frame.width)")
                view.removeFromSuperview()
            }
        }
        self.drawnMarkers = 0
    }
    
    func redrawMarkers() {
        self.removeInjuryMarkers()
        if !self.scroll.decelerating {
            self.addInjuryMarkers()
        }
    }
    
    func zoomToInjury(injuryIcon: IconView) {
        var scale = self.scroll.zoomScale
        var height = self.image.frame.height / MAX_ZOOM_FACTOR / scale
        var width = self.image.frame.width / MAX_ZOOM_FACTOR / scale
        var newFrame : CGRect = CGRectMake(CGFloat(injuryIcon.pxX) - 0.5 * width, CGFloat(injuryIcon.pxY) - 0.5 * height, width, height)
        self.scroll.zoomToRect(newFrame, animated: true)
        self.redrawMarkers()
    }
    
    //DELEGATE METHODS
    
    func didUpdateInjuries() {
        var array = self.delegate?.injuries
        self.injuries = NSMutableArray(array: array!)
        self.redrawMarkers()
        println("injuries redrawn")
    }
    
    func didPressIcon(icon: IconView) {
        //TODO refactor
        if icon.number.text == "1" {
            self.addInjuryNamesPopover(icon.frame.origin.x+icon.frame.width/2, y: icon.frame.origin.y+icon.frame.height/2, injuries: icon.injuries)
            // show dropdown list of choices
        } else if (self.scroll.zoomScale + 0.5) > 7 {
            self.addInjuryNamesPopover(icon.frame.origin.x+icon.frame.width/2, y: icon.frame.origin.y+icon.frame.height/2, injuries: icon.injuries)
            // show dropdown list of choices
        } else {
            self.zoomToInjury(icon)
        }
    }
    
    func didChooseInjuryToShow(injury: Injury) {
        self.selectedInjury = injury
        self.performSegueWithIdentifier("showDetails", sender: self)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        self.removeInjuryMarkers()
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!){
        self.removeInjuryMarkers()
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.removeInjuryMarkers()
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        self.redrawMarkers()
        print(self.scroll.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.redrawMarkers()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.redrawMarkers()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.image
    }
}
    


