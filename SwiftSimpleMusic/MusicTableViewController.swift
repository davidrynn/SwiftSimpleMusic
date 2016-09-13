//
//  MusicTableViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/10/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicTableViewController: UITableViewController {
    
    private var player: MusicPlayer!
    private var collection: MediaCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return collection.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let item = collection.items[indexPath.row]
        
        cell.textLabel?.text = item.title
        let cellImage: UIImage?
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSizeMake(cell.imageView!.size.width*imageViewModifier, cell.imageView!.size.height*imageViewModifier)
        if let itemImage = item.artwork {
            cellImage = itemImage.imageWithSize(cellImageSize)
        } else {
            cellImage = UIImage(named: "noteSml.png")
        }
        cell.imageView!.image = cellImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = collection.items[indexPath.row]
        
        if let nowPlayingItem = player.nowPlayingSong() {
            
            if (nowPlayingItem.title == item.title){
                if player.playingStatus() == MPMusicPlaybackState.Playing {
                    player.pause()
                } else {
                    player.playItem(item)
                }
                
            } else {
                player.stop()
                player.playItem(item)
            }
        } else {
            player.playItem(item)
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
    
}
extension MusicTableViewController: Injectable {
    
    func inject(item: MusicPlayer) {
        player = item
        collection = item.collection
    }
    
    func assertDependencies() {
        assert(player != nil)
    }
    
}
