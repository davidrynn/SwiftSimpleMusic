//
//  MusicPlayer.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicPlayer {
    
    let player: MPMusicPlayerController
    var nextSong: MPMediaItem?
    var previousSong: MPMediaItem?
    //    var musicCollection: MPMediaItemCollection
    //    var randomizedCollection: MPMediaItemCollection
    var shuffleMode: MPMusicShuffleMode {
        didSet {
            player.shuffleMode = self.shuffleMode
        }
    }
    var collection: MediaCollection
    
    
    init() {
        
        self.player = MPMusicPlayerController.systemMusicPlayer()
        let query = MPMediaQuery.songs()
        print("Number of songs: \(String(query.items!.count))")
        let items = query.items!
        self.collection = MediaCollection(items: items)
        self.player.setQueue(with: MPMediaQuery.songs())
        self.shuffleMode = MusicPlayer.shuffleModeFromDefaults()
        player.beginGeneratingPlaybackNotifications()
        
    }
    
    fileprivate class func shuffleModeFromDefaults() -> MPMusicShuffleMode {
        let defaults = UserDefaults.standard
        if let shuffleMode: Int = defaults.integer(forKey: "shuffleMode") {
            return MPMusicShuffleMode(rawValue: shuffleMode)!
        } else {
            return MPMusicShuffleMode.off
        }
    }
    
    func setPlayerQueue(_ query: MPMediaQuery) {
        player.setQueue(with: query)
        collection = MediaCollection(items: query.items!)
    }

    func play() {
        self.player.play()
        
    }
    
    func currentSong() -> MPMediaItem? {
        return player.nowPlayingItem
    }
    
    func playItem(_ item: MPMediaItem) {
        
        player.nowPlayingItem = item
        player.play()
    }
    
    func stop() {
        player.stop()
        
    }
    
    func nowPlayingSong() -> MPMediaItem? {
        return player.nowPlayingItem
    }
    
    func playingStatus() -> MPMusicPlaybackState {
        return player.playbackState
    }
    
    func pause() {
        
        player.pause()
        
    }
    
    func forward() {
        
        player.skipToNextItem()
        //fast forward on long press
        //next on one press
    }
    
    func rewind() {
        if player.indexOfNowPlayingItem > 0 {
            player.skipToPreviousItem()
        }
        //rewind on long press
        //to beginning of song on one press
        //to previous on double tap
    }
    
    deinit{
        player.endGeneratingPlaybackNotifications()
    }
    
    
}
