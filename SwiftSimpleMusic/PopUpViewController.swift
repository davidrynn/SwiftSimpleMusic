//
//  PopUpViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit
import MediaPlayer

class PopUpViewController: UIViewController {
    
    var player: MusicPlayerProtocol!
    var topBarOpacity: CGFloat = 1 {
        didSet {
            let view = self.view as! PopUpView
            view.topBarOpacity = topBarOpacity
            view.layoutSubviews()
        }
    }
    
    override func loadView() {
        super.loadView()
        let popUpView = PopUpView.instanceFromNib()
 //       popUpView.topBar = PopUpTopBarView.instanceFromNib()
        self.view = popUpView

        setupNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupNotifications() {
        
        let notificationCenter: NotificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateArtworkImage), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        notificationCenter.addObserver(self, selector: #selector(displayErrorMessage), name: NSNotification.Name(rawValue: "errorMessage"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getView() -> PopUpView {
        return self.view as! PopUpView
    }
    
    @objc func updateArtworkImage() {
        if (player.currentSong != nil) {
            if let item = player.currentSong {
                if let view = view as? PopUpView {
                    var newImage = UIImage(named: "noteSml.png")!
                    if let artwork = item.artwork, let linkedImage = artwork.image(at: view.imageView.bounds.size)  {
                        newImage = linkedImage
                    }
                    view.topBarImageView.image = newImage
                    view.imageView.image = newImage
                    if let labelText = item.title {
                        view.labelText = labelText
                        view.topBarLabel.text = labelText
                    }
//                    reloadInputViews()
//                    view.setNeedsLayout()
                    view.layoutSubviews()
                    view.topBar.layoutSubviews()
                }
            }
        }
    }
    
    @objc func displayErrorMessage(notification: Notification){
        if let message = notification.userInfo?["message"] as? String {
            let view = getView()
            view.labelText = message
            view.layoutSubviews()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
