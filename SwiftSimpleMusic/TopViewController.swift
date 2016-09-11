//
//  TopViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/10/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet weak var container: MusicTableViewController!
    @IBOutlet weak var playbackControlView: UIView!
    
    let popUpViewController = PopUpViewController()
    var lastLocation: CGPoint = CGPointMake(0, 0)
    lazy var popUpViewY: CGFloat = {
        
        return self.view.frame.size.height*4/5
        
    }()
    let player: MusicPlayer = MusicPlayer()
    
    override func viewDidLoad() {
 
        super.viewDidLoad()
        self.addChildViewController(popUpViewController)
        self.view.addSubview(popUpViewController.view)
        popUpViewController.didMoveToParentViewController(self)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.detectPan(_:)))
        popUpViewController.view.gestureRecognizers = [panRecognizer]
        
    }
    
    //put viewdidlayout so that we know everything else is formatted correctly before subviews are layed out.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popUpViewController.view.frame = CGRectMake(0, self.popUpViewY, self.view.frame.size.width, self.view.height)
//        playbackControlView.frame = CGRectMake(0, self.view.height*7/8, self.view.width, self.view.height*7/8)
        self.view.bringSubviewToFront(playbackControlView)
        
    }
    
    func detectPan(recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translationInView(self.view)
        self.popUpViewController.view.center.y = lastLocation.y + translation.y
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseInOut, animations: {
                if self.popUpViewController.view.center.y >= self.view.height {
                    self.popUpViewController.view.y = self.popUpViewY
                } else {
                    self.popUpViewController.view.centerVerticallyInSuperview()
                }
                }, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastLocation = self.popUpViewController.view.center
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //remove observer eg
        popUpViewController.willMoveToParentViewController(nil)
        popUpViewController.removeFromParentViewController()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMusicTableViewController" {
            let dVC = segue.destinationViewController as? MusicTableViewController
            dVC?.inject(player)
        }
    }

}
