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
import StoreKit

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

enum PlaybackError: Error, LocalizedError {
    /// The song is Apple Music or iCloud content and this device can't play catalog music.
    case subscriptionRequired(title: String?)
    case unavailable(title: String?)

    var errorDescription: String? {
        switch self {
        case .subscriptionRequired(let title):
            return "\(Self.songName(title)) needs an active Apple Music subscription to play."
        case .unavailable(let title):
            return "\(Self.songName(title)) can't be played right now. It may need to be downloaded, or require an Apple Music subscription."
        }
    }

    private static func songName(_ title: String?) -> String {
        title.map { "\"\($0)\"" } ?? "This song"
    }
}

extension Notification.Name {
    /// Posted on the main thread when a song fails to prepare. `userInfo[MusicPlayer.playbackErrorKey]` holds a `PlaybackError`.
    static let musicPlayerPlaybackFailed = Notification.Name("MusicPlayerPlaybackFailed")
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

// MPMusicPlayerController must be created and driven on the main thread;
// off-main creation leaves the application queue player unable to connect.
@MainActor
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
    // Don't filter on assetURL: it's nil for DRM-protected and Apple Music
    // tracks, which MPMusicPlayerController still plays fine.
    func reloadLibraryQueue() {
        setPlayerQueue(with: MPMediaQuery.songs())
    }

    func setPlayerQueue(with query: MPMediaQuery) {
        let items = query.items ?? []
        player.setQueue(with: query)
        collection = MediaCollection(items: items)
        print("Set queue from query. Items: \(items.count)")
    }

    func setPlayerQueue(with collection: MPMediaItemCollection) {
        player.setQueue(with: collection)
        self.collection = MediaCollection(collection: collection)
        print("Set queue from collection. Items: \(collection.items.count)")
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
        prepareAndPlay(player.nowPlayingItem)
    }
    
    func playItem(_ item: MPMediaItem) {
        let currentShuffleMode = player.shuffleMode
        player.shuffleMode = .off
        player.nowPlayingItem = item
        prepareAndPlay(item) { [weak self] in
            self?.player.shuffleMode = currentShuffleMode
        }
    }

    static let playbackErrorKey = "error"

    /// Prepares the queue and plays, or posts `.musicPlayerPlaybackFailed` if the item can't be played.
    private func prepareAndPlay(_ item: MPMediaItem?, completion: (@MainActor () -> Void)? = nil) {
        let title = item?.title
        let needsCatalogAccess = item.map { $0.hasProtectedAsset || $0.isCloudItem } ?? false
        player.prepareToPlay { [weak self] error in
            Task { @MainActor in
                defer { completion?() }
                guard let self else { return }
                guard let error else {
                    self.player.play()
                    return
                }
                print("Failed to prepare \(title ?? "<unknown>"): \(error)")
                let playbackError: PlaybackError
                if needsCatalogAccess, await MusicPlayer.canPlayCatalogMusic() == false {
                    playbackError = .subscriptionRequired(title: title)
                } else {
                    playbackError = .unavailable(title: title)
                }
                NotificationCenter.default.post(
                    name: .musicPlayerPlaybackFailed,
                    object: self,
                    userInfo: [MusicPlayer.playbackErrorKey: playbackError]
                )
            }
        }
    }

    /// Whether this device/account can play Apple Music catalog content; nil if it couldn't be determined.
    static func canPlayCatalogMusic() async -> Bool? {
        guard SKCloudServiceController.authorizationStatus() == .authorized else { return nil }
        return await withCheckedContinuation { continuation in
            SKCloudServiceController().requestCapabilities { capabilities, error in
                continuation.resume(returning: error == nil ? capabilities.contains(.musicCatalogPlayback) : nil)
            }
        }
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
    
    isolated deinit {
        player.endGeneratingPlaybackNotifications()
    }
    
    
}

