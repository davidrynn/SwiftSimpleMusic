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
    
    var player: MusicPlayer!
    
    override func loadView() {
        super.loadView()
        self.view = PopUpView.instanceFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleNotifications() {
        
        let notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: <#T##Selector#>, name: <#T##String?#>, object: <#T##AnyObject?#>)
            [NSNotificationCenter   defaultCenter];
        [notificationCenter addObserver:self
            selector:@selector(handleNowPlayingItemChanged:)
        name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
        object:self.musicPlayer];
    NSNotificationCenter.defaultCenter().addObserver(
    self,
    selector: #selector(batteryLevelChanged),
    name: UIDeviceBatteryLevelDidChangeNotification,
    object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getView() -> PopUpView {
        return self.view as! PopUpView
    }
    
    func updateArtworkImage(item: MPMediaItem) {
        if let view = view as? PopUpView {
            let newImage: UIImage
            if let artwork = item.artwork {
                newImage = (artwork.imageWithSize(view.imageView.size))!
            } else {
                newImage = UIImage(named: "noteSml.png")!
            }
            view.imageView.image = newImage
            reloadInputViews()
            view.setNeedsLayout()
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
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
