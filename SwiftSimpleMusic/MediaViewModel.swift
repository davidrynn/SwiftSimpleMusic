//
//  MediaViewModel.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/18/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

struct MediaViewModel {
    //    let mediaGroupCollection: GroupCollectionProtocol
    
    let player: MusicPlayerProtocol
    let sortType: MediaSortType
    var firstTimeTap: Bool = true
    var collections: [MPMediaItemCollection]?
    var items: [MPMediaItem]?
    
    
    init(player: MusicPlayerProtocol, sortType: MediaSortType, query: MPMediaQuery, firstTimeTap: Bool) {
        self.player = player
        self.sortType = sortType
        self.firstTimeTap = firstTimeTap
        self.collections = query.collections
        self.items = query.items
    }
    
    init(player: MusicPlayerProtocol, sortType: MediaSortType, grouping: GroupCollectionProtocol, firstTimeTap: Bool) {
        self.player = player
        self.sortType = sortType
        self.collections = grouping.collections
        self.items = grouping.items
        self.firstTimeTap = firstTimeTap
    }
    
    func titleForSection(section: Int) -> String {
        guard let items = items, let collections = collections else { return "" }
        switch sortType {
        case .albums, .audiobooks, .compilations:
            return items[0].albumTitle ?? ""
        case .artists:
            return collections[section].representativeItem?.albumTitle ?? ""
        case .genres:
            return items[0].genre ?? ""
        case .songs:
            return items[0].title ?? ""
        case .playlists:
            //         guard let playlist = mediaCollection as? MPMediaPlaylist else { return "" }
            return  ""
        case .podcasts:
            return items[0].podcastTitle ?? ""
        }
    }
    
    func heightForSectionHeader() -> CGFloat {
        switch sortType {
        case .artists:
            return 50.0
        default:
            return 120.0
        }
    }
    
    func numberOfSections() -> Int{
        if let collections = collections, sortType == .artists {
            return collections.count
        }
        return 1
    }
    
    
    func numberOfRowsForSection(section: Int) -> Int {
        if let collections = collections, sortType == .artists {
            return collections[section].items.count
        }
        if let items = items {
            return items.count
        }
        return 0
    }
    
    func cellImage(indexPath: IndexPath) -> UIImage {
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSize(width: 40*imageViewModifier, height: 40*imageViewModifier)
        guard let collections = collections,
            let artwork = collections[indexPath.section].items[indexPath.row].artwork, let image = artwork.image(at: cellImageSize) else {
                return UIImage(named: "noteSml.png")!
        }
        return image
    }
    
    func cellLabelText(indexPath: IndexPath) -> String {
        guard let collections = collections, let title = collections[indexPath.section].items[indexPath.row].title else { return ""}
        return title
    }
    
    mutating func didSelectSongAtRowAt(indexPath: IndexPath) {
        let item: MPMediaItem?
        if sortType == .artists {
            item = collections?[indexPath.section].items[indexPath.row]
        } else {
            item = items?[indexPath.row]
        }
        guard let _ = item else { return }
        //if it's the first time selecting something on this view, change the player queue so not stuck on old queue
        if firstTimeTap {
            if sortType == .artists {
                if let collections = collections {
                    player.setPlayerQueue(with: collections[indexPath.section])
                }
            } else {
                player.setPlayerQueue(with: MPMediaItemCollection(items: items!))
            }
            firstTimeTap = false
        }
        togglePlaying(item: item!)
    }
    
    func togglePlaying(item: MPMediaItem){
        //if user taps on song already playing pause, otherwise play song
        if let nowPlayingItem = player.currentSong, nowPlayingItem.title == item.title, player.currentPlaybackState() == MPMusicPlaybackState.playing {
            player.pause()
            return
        }
        player.playItem(item)
    }
    
}
