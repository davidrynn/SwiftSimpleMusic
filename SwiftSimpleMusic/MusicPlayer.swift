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
    var currentSong: MPMediaItem?
    var nextSong: MPMediaItem?
    var previousSong: MPMediaItem?
    //    var musicCollection: MPMediaItemCollection
    //    var randomizedCollection: MPMediaItemCollection
    var shuffleMode: MPMusicShuffleMode
    var collection: MediaCollection
    
    
    init() {
        
        self.player = MPMusicPlayerController.systemMusicPlayer()
        let query = MPMediaQuery.songsQuery()
        print("Number of songs: \(String(query.items!.count))")
        self.collection = MediaCollection(items: query.items!)
        self.player.setQueueWithQuery(MPMediaQuery.songsQuery())
        self.currentSong = player.nowPlayingItem
        //        self.previousSong = player.ne
        self.shuffleMode = MusicPlayer.shuffleModeFromDefaults()
        
    }
    
    private class func shuffleModeFromDefaults() -> MPMusicShuffleMode {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let shuffleMode: Int = defaults.integerForKey("shuffleMode") {
            return MPMusicShuffleMode(rawValue: shuffleMode)!
        } else {
            return MPMusicShuffleMode.Off
        }
    }
    
    func play() {
        self.player.play()
        
    }
    
    func playItem(item: MPMediaItem) {
        
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
        
        player.skipToPreviousItem()
        //rewind on long press
        //to beginning of song on one press
        //to previous on double tap
    }
    
    
}