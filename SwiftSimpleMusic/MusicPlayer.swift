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
    var repeatMode: MPMusicRepeatMode { get set }
    var shuffleMode: MPMusicShuffleMode { get set }
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
    func toggleShuffleMode(shuffleButton: UIBarButtonItem)
    func toggleLoopMode(loopButton: UIBarButtonItem)
    func currentPlaybackState()-> MPMusicPlaybackState
    func setPlayerQueue(with: MPMediaQuery)
    func setPlayerQueue(with: MPMediaItemCollection)
    
}

class MusicPlayer: MusicPlayerProtocol {
    
    var player: MPMusicPlayerController
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
        set {
            self.player.nowPlayingItem = newValue
        }
    }
    
    var repeatMode: MPMusicRepeatMode {
        set {
            player.repeatMode = self.repeatMode
        }
        
        get {
            return player.repeatMode
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
        
        self.player = MPMusicPlayerController.systemMusicPlayer
        let query = MPMediaQuery.songs()
        
        let items: [MPMediaItem] = query.items ?? []
        self.collection = MediaCollection(items: items)
        self.player.setQueue(with: MPMediaQuery.songs())
        self.shuffleMode = player.shuffleMode
        self.repeatMode = player.repeatMode
        player.beginGeneratingPlaybackNotifications()

    }
    
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
        let currentShuffleMode = player.shuffleMode
        player.shuffleMode = .off
        player.nowPlayingItem = item
        player.play()
        player.shuffleMode = currentShuffleMode
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

    
    func toggleShuffleMode(shuffleButton: UIBarButtonItem) {
        if (player.shuffleMode == MPMusicShuffleMode.off || player.shuffleMode.rawValue == 0) {
            player.shuffleMode = MPMusicShuffleMode.songs
            shuffleButton.image = UIImage(named: "shuffle2")
        }
        else {
            player.shuffleMode = MPMusicShuffleMode.off
            shuffleButton.image = UIImage(named: "shuffle1")
        }
    }
    
    func toggleLoopMode(loopButton: UIBarButtonItem) {
        
        if repeatMode == .none {
            player.repeatMode = .all
            loopButton.image = #imageLiteral(resourceName: "loop3")
        }
        else if repeatMode == .all {
            player.repeatMode = .one
            loopButton.image = #imageLiteral(resourceName: "loop2")
        }
        else if player.repeatMode == .one {
            player.repeatMode = .none
            loopButton.image = #imageLiteral(resourceName: "loop1")
        }
    }
    
    deinit{
        player.endGeneratingPlaybackNotifications()
    }
    
    
}
