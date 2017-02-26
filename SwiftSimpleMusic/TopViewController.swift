//
//  TopViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/10/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit
import MediaPlayer

class TopViewController: UIViewController {
    @IBOutlet weak var forwardButton: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var container: MainMusicTableViewController!
    @IBOutlet weak var playbackControlView: UIView!
    
    let popUpViewController = PopUpViewController()
    var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
    lazy var popUpViewY: CGFloat = {
        
        return self.view.frame.size.height*4/5
        
    }()
    let player: MusicPlayer = MusicPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addChildViewController(popUpViewController)
        self.view.addSubview(popUpViewController.view)
        popUpViewController.didMove(toParentViewController: self)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.detectPan(_:)))
        popUpViewController.view.gestureRecognizers = [panRecognizer]
        popUpViewController.player = player
        
    }
    
    //put viewdidlayout so that we know everything else is formatted correctly before subviews are layed out.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popUpViewController.view.frame = CGRect(x: 0, y: self.popUpViewY, width: self.view.frame.size.width, height: self.view.height)
        self.view.bringSubview(toFront: playbackControlView)
        
    }
    func setupButtons(){
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TopViewController.backButtonTapped(_:))  //Tap function will call when user tap on button
        //        let longGesture = UILongPressGestureRecognizer(target: self, action: "Long") //Long function will call when user long press on button.
        //        tapGesture.numberOfTapsRequired = 1
        //        .addGestureRecognizer(tapGesture)
        //        btn.addGestureRecognizer(longGesture)
    }
    
    
    //    MARK: Actions
    
    func detectPan(_ recognizer: UIPanGestureRecognizer){
        guard let popUpView = popUpViewController.view as? PopUpView else {
            return
        }
        let translation = recognizer.translation(in: self.view)
        popUpView.center.y = lastLocation.y + translation.y
        if recognizer.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                //if direction up
                if translation.y < 0 {
                if popUpView.center.y >= self.view.height*2/3 {
                    popUpView.y = self.popUpViewY
                } else {
                    popUpView.centerVerticallyInSuperview()
                }
                } else {
                    //if direction down
                    if popUpView.center.y < self.view.height/3 {
                        popUpView.centerVerticallyInSuperview()
                    } else {
                        popUpView.y = self.popUpViewY
                    }                    

                }
            }, completion: nil)
        }
        
        //fade top bar
        let fadeStartY: CGFloat = self.view.height/2
        if popUpView.y < fadeStartY {
            popUpViewController.topBarOpacity = CGFloat(popUpView.y/fadeStartY)
        } else {
            popUpViewController.topBarOpacity = 1.0
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastLocation = self.popUpViewController.view.center
    }
    
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        
        if player.currentPlaybackState() == MPMusicPlaybackState.playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
    
    //    @IBAction func forwardButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
    //        player.seekForward { () -> (Bool) in
    //            if sender.state == UIGestureRecognizerState.ended {
    //                return true
    //            }
    //            return false
    //        }
    //    }
    
    //    @IBAction func forwardButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
    //        sender.minimumPressDuration = 1.0
    //        if sender.state == UIGestureRecognizerState.ended {
    //print("longpress ended")
    //        }
    //        if sender.state == UIGestureRecognizerState.began {
    //            print("longpress began")
    //        }
    //                player.seekForward { () -> (Bool) in
    //                    if sender.state == UIGestureRecognizerState.ended {
    //                        return true
    //                    }
    //                    return false
    //                }
    //    }
    @IBAction func forwardButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 1.0
        if sender.state == UIGestureRecognizerState.ended {
            player.endSeeking()
        }
        if sender.state == UIGestureRecognizerState.began {
            player.beginSeekingForward()
        }
    }
    @IBAction func forwardButtonTapped(_ sender: UITapGestureRecognizer) {
        player.skipToNextItem()
    }
    
    @IBAction func backButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 1.0
        if sender.state == UIGestureRecognizerState.ended {
            player.endSeeking()
        }
        if sender.state == UIGestureRecognizerState.began {
            player.beginRewind()
        }
        
    }
    
    
    @IBAction fileprivate func backButtonTapped(_ sender: UITapGestureRecognizer) {
        player.playPreviousItem()
    }
    
    
    
    //    MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMusicTableViewController" {
            let dVC = segue.destination as? UINavigationController
            if let mainVC = dVC?.topViewController as? MainMusicTableViewController {
                mainVC.inject(player)
            } else {
                
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning dude")
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //remove observer eg
        popUpViewController.willMove(toParentViewController: nil)
        popUpViewController.removeFromParentViewController()
    }
    
}

