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

        //        playbackControlView.frame = CGRectMake(0, self.view.height*7/8, self.view.width, self.view.height*7/8)
        self.view.bringSubview(toFront: playbackControlView)
        
    }
    //    MARK: Actions
    
    func detectPan(_ recognizer: UIPanGestureRecognizer){
        
        let view = popUpViewController.view as? PopUpView
        let imageView = view?.imageView
        
        
        let translation = recognizer.translation(in: self.view)
        popUpViewController.view.center.y = lastLocation.y + translation.y
        let transationalY = popUpViewController.view.center.y
        
        imageView?.frame = CGRect(x: 0, y: 0, width: transationalY, height: transationalY)
        print("image view center: \(imageView?.center)")
        
        if recognizer.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                if self.popUpViewController.view.center.y >= self.view.height {
                    self.popUpViewController.view.y = self.popUpViewY
                } else {
                    self.popUpViewController.view.centerVerticallyInSuperview()
                }
                }, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastLocation = self.popUpViewController.view.center
    }
    
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        
        if player.playingStatus() == MPMusicPlaybackState.playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction fileprivate func forwardButtonTapped(_ sender: AnyObject) {
        
        player.forward()
//        if let currentSong = player.currentSong() {
//            popUpViewController.updateArtworkImage(currentSong)
//        }
    }
    
    @IBAction fileprivate func backButtonTapped(_ sender: AnyObject) {
        
        player.rewind()
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
