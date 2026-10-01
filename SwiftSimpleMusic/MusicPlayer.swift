//
//  MusicPlayer.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFAudio

enum MusicPlayerError: Error, LocalizedError {
    case mediaLibraryAccessDenied
    case mediaLibraryAccessRestricted
    case mediaLibraryAccessNotDetermined
    case mediaLibraryAccessUnknown

    var errorDescription: String? {
        switch self {
        case .mediaLibraryAccessDenied:
            return "Media Library access was denied."
        case .mediaLibraryAccessRestricted:
            return "Media Library access is restricted on this device."
        case .mediaLibraryAccessNotDetermined:
            return "Media Library access has not been determined."
        case .mediaLibraryAccessUnknown:
            return "Media Library access failed due to an unknown reason."
        }
    }
}

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

final class MusicPlayer: @MainActor MusicPlayerProtocol {
    
    private func configureAudioSessionIfNeeded() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
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
            player.repeatMode = newValue
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
    
    init() async throws {
        self.player = MPMusicPlayerController.applicationMusicPlayer

        // Start with an empty collection; we'll load after auth.
        self.collection = MediaCollection(items: [])
        self.shuffleMode = player.shuffleMode
        self.repeatMode = player.repeatMode
        player.beginGeneratingPlaybackNotifications()

        // Optionally attempt to load immediately if already authorized.
        if MPMediaLibrary.authorizationStatus() == .authorized {
            configureAudioSessionIfNeeded()
            reloadLibraryQueue()
        } else if MPMediaLibrary.authorizationStatus() == .notDetermined {
            let status = await MusicPlayer.requestMediaLibraryAccess()
            switch status {
            case .authorized:
                configureAudioSessionIfNeeded()
                reloadLibraryQueue()
            case .denied:
                throw MusicPlayerError.mediaLibraryAccessDenied
            case .restricted:
                throw MusicPlayerError.mediaLibraryAccessRestricted
            case .notDetermined:
                throw MusicPlayerError.mediaLibraryAccessNotDetermined
            @unknown default:
                throw MusicPlayerError.mediaLibraryAccessUnknown
            }
        } else {
            // Handle other statuses returned by `authorizationStatus()` proactively
            switch MPMediaLibrary.authorizationStatus() {
            case .denied:
                throw MusicPlayerError.mediaLibraryAccessDenied
            case .restricted:
                throw MusicPlayerError.mediaLibraryAccessRestricted
            case .notDetermined:
                throw MusicPlayerError.mediaLibraryAccessNotDetermined
            @unknown default:
                throw MusicPlayerError.mediaLibraryAccessUnknown
            }
        }
    }
    static func requestMediaLibraryAccess() async -> MPMediaLibraryAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            MPMediaLibrary.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }
    // Rebuild the queue with on-device playable items only.
    func reloadLibraryQueue() {
        let query = MPMediaQuery.songs()

        // Exclude cloud-only items.
        let notCloud = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        query.addFilterPredicate(notCloud)

        // Filter to items with an asset URL (playable by the app).
        let playableItems = (query.items ?? []).filter { $0.assetURL != nil }

        self.collection = MediaCollection(items: playableItems)
        self.player.setQueue(with: MPMediaItemCollection(items: playableItems))
        self.player.prepareToPlay()

        print("Reloaded queue. Playable items: \(playableItems.count)")
    }

    func setPlayerQueue(with query: MPMediaQuery) {
        // Ensure we only queue playable items.
        let notCloud = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        query.addFilterPredicate(notCloud)
        let playableItems = (query.items ?? []).filter { $0.assetURL != nil }

        player.setQueue(with: MPMediaItemCollection(items: playableItems))
        collection = MediaCollection(items: playableItems)
        player.prepareToPlay()
        print("Set queue from query. Playable items: \(playableItems.count)")
    }

    func setPlayerQueue(with collection: MPMediaItemCollection) {
        // Ensure we only queue playable items.
        let playableItems = collection.items.filter { $0.assetURL != nil }
        player.setQueue(with: MPMediaItemCollection(items: playableItems))
        self.collection = MediaCollection(items: playableItems)
        player.prepareToPlay()
        print("Set queue from collection. Playable items: \(playableItems.count)")
    }
//    func setPlayerQueue(with query: MPMediaQuery) {
//        player.setQueue(with: query)
//        collection = MediaCollection(items: query.items ?? [])
//    }
//    
//    func setPlayerQueue(with collection: MPMediaItemCollection) {
//        player.setQueue(with: collection)
//        self.collection = MediaCollection(collection: collection)
//    }
    
    func play() {
        guard !collection.items.isEmpty else {
            print("No playable items in queue; aborting play()")
            return
        }
        player.play()
    }
    
    func playItem(_ item: MPMediaItem) {
        let currentShuffleMode = player.shuffleMode
        player.shuffleMode = .off
        player.nowPlayingItem = item
        player.prepareToPlay()
        print("Attempting to play specific item: \(item.title ?? "<unknown>")")
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

    
    @MainActor func toggleShuffleMode(shuffleButton: UIBarButtonItem) {
        if (player.shuffleMode == MPMusicShuffleMode.off || player.shuffleMode.rawValue == 0) {
            player.shuffleMode = MPMusicShuffleMode.songs
            shuffleButton.image = UIImage(named: "shuffle2")
        }
        else {
            player.shuffleMode = MPMusicShuffleMode.off
            shuffleButton.image = UIImage(named: "shuffle1")
        }
    }
    
    @MainActor func toggleLoopMode(loopButton: UIBarButtonItem) {
        
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

