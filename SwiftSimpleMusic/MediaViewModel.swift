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
    let groupStruct: GroupCollectionProtocol
    var firstTimeTap: Bool = true
    var collections: [MPMediaItemCollection] { return groupStruct.collections }
    var items: [MPMediaItem] { return groupStruct.items }
    
    
    func titleForSection(section: Int) -> String {
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
        if sortType == .artists {
            return collections.count
        }
        return 1
    }
    
    
    func numberOfRowsForSection(section: Int) -> Int {
        if sortType == .artists {
            return collections[section].items.count
        }
        return items.count
    }
    
    func cellImage(indexPath: IndexPath) -> UIImage {
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSize(width: 40*imageViewModifier, height: 40*imageViewModifier)
        return collections[indexPath.row].items[indexPath.row].artwork?.image(at: cellImageSize) ?? UIImage(named: "noteSml.png")!
    }
    
    func cellLabelText(indexPath: IndexPath) -> String {
        let mediaItem: MPMediaItem = collections[indexPath.section].items[indexPath.row]
        return mediaItem.title ?? ""
    }
    
    mutating func didSelectSongAtRowAt(indexPath: IndexPath) {
        var item = items[indexPath.row]
        if sortType == .artists {
            item = collections[indexPath.section].items[indexPath.row]
        }
        //if it's the first time selecting something on this view, change the player queue so not stuck on old queue
        if firstTimeTap {
            if sortType == .artists {
                player.setPlayerQueue(with: collections[indexPath.section])
            } else {
                player.setPlayerQueue(with: MPMediaItemCollection(items: items))
            }
            firstTimeTap = false
        }
        togglePlaying(item: item)
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
