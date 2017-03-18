//
//  MusicPlayer.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

protocol MusicPlayerProtocol {
    
    var currentSong: MPMediaItem? { get }
    var nextSong: MPMediaItem? { get }
    var previousSong: MPMediaItem? { get }
    var collection: MediaCollection { get }
    func play()
    func playItem(_ item: MPMediaItem)
    func beginSeekingForward()
    func endSeeking()
    func beginRewind()
    func skipToNextItem()
    func playPreviousItem()
    func pause()
    func stop()
    func toggleShuffleMode()
    func currentPlaybackState()-> MPMusicPlaybackState
    func setPlayerQueue(with: MPMediaQuery)
    func setPlayerQueue(with: MPMediaItemCollection)
    
}

class MusicPlayer: MusicPlayerProtocol {
    
    let player: MPMusicPlayerController
    var nextSong: MPMediaItem? {
        get {
            let indexNextSong = player.indexOfNowPlayingItem + 1
            let songCollection = self.collection.items
            if indexNextSong < songCollection.count {
                return self.collection.items[indexNextSong]
            } else {
                return nil
            }
        }
    }
    var previousSong: MPMediaItem? {
        get {
            let indexPreviousSong = player.indexOfNowPlayingItem - 1
            if indexPreviousSong >= 0 {
                return self.collection.items[indexPreviousSong]
            } else {
                return nil
            }
        }
    }
    var currentSong: MPMediaItem? {
        get {
            return self.player.nowPlayingItem
        }
    }
    
    var repeatMode: MPMusicRepeatMode {
        didSet {
            player.repeatMode = self.repeatMode
        }
    }
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
        
        let items = query.items!
        self.collection = MediaCollection(items: items)
        self.player.setQueue(with: MPMediaQuery.songs())
        self.shuffleMode = player.shuffleMode
        self.repeatMode = player.repeatMode
        player.beginGeneratingPlaybackNotifications()

    }
    
    //    fileprivate func collection(query: MPMediaQuery) -> MediaCollection {
    //        let items = query.items!
    //        return MediaCollection(items: items)
    //    }
    
//    fileprivate class func shuffleModeFromDefaults() -> MPMusicShuffleMode {
//        let defaults = UserDefaults.standard
//        if let shuffleModeRaw: Int = defaults.integer(forKey: "shuffleMode") {
//            return MPMusicShuffleMode(rawValue: shuffleModeRaw)!
//        } else {
//            return MPMusicShuffleMode.off
//        }
//    }
    
    func setPlayerQueue(with query: MPMediaQuery) {
        player.setQueue(with: query)
        collection = MediaCollection(items: query.items!)
    }
    
    func setPlayerQueue(with collection: MPMediaItemCollection) {
        player.setQueue(with: collection)
        self.collection = MediaCollection(collection: collection)
    }
    
    func play() {
        self.player.play()
    }
    
    func playItem(_ item: MPMediaItem) {
        player.nowPlayingItem = item
        player.play()
    }
    
    func stop() {
        player.stop()
        
    }
    
    func currentPlaybackState() -> MPMusicPlaybackState {
        return player.playbackState
    }
    
    func pause() {
        
        player.pause()
        
    }
    
    func skipToNextItem() {
        player.skipToNextItem()
    }
    
    func playPreviousItem() {
        if player.indexOfNowPlayingItem > 0 {
            player.skipToPreviousItem()
        }
    }
    
    func beginSeekingForward() {
            player.beginSeekingForward()

    }
    
    func endSeeking(){
        player.endSeeking()
    }
    
    func beginRewind(){
        player.beginSeekingBackward()
    }

    
    func toggleShuffleMode() {
        
    }
    
    deinit{
        player.endGeneratingPlaybackNotifications()
    }
    
    
}
