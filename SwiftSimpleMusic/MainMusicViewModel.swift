//
//  MainMusicViewModel.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

//struct SectionStruct {
//    let title: String
//    var songs: [MPMediaItem]
//}

protocol GroupCollectionProtocol {

    var items: [MPMediaItem] { get set }
    var query: MPMediaQuery { get }
    var sections: [MPMediaQuerySection] { get set }
    func sectionHeaders(query: MPMediaQuery) -> [String]
}

struct SongsGroupCollection: GroupCollectionProtocol {
    
    var query: MPMediaQuery
    var items: [MPMediaItem]
    var sections: [MPMediaQuerySection]
    
    init(query: MPMediaQuery) {
        self.query = query
        self.items = query.items ?? []
        self.sections = query.itemSections ?? []
    }
    
    func sectionHeaders(query: MPMediaQuery) -> [String] {
        var returnStringArray: [String] = []
        if let sections = query.itemSections {
            for section in sections {
                returnStringArray.append(section.title)
            }
        }
        return returnStringArray
    }
}

struct AlbumsGroupCollection: GroupCollectionProtocol {
    var items: [MPMediaItem]
    var query: MPMediaQuery
    var sections: [MPMediaQuerySection]
    
    init(query: MPMediaQuery){
        self.query = query
        self.sections = query.collectionSections ?? []
        var returnValue: [MPMediaItem] = []
        if let queryCollections = query.collections {
        queryCollections.forEach {
            guard $0.representativeItem != nil else { return }
            returnValue.append($0.representativeItem!)
            }
        }
        self.items = returnValue
    }
  
    func sectionHeaders(query: MPMediaQuery) -> [String] {
        var returnStringArray: [String] = []
        if let sections = query.collectionSections {
            for section in sections {
                returnStringArray.append(section.title)
            }
        }
        return returnStringArray
    }
}

struct ArtistsGroupCollection: GroupCollectionProtocol {
    var items: [MPMediaItem]
    var query: MPMediaQuery
    var sections: [MPMediaQuerySection]
    
    init(){
        self.query = MPMediaQuery.artists()
        self.sections = query.collectionSections ?? []
        var returnValue: [MPMediaItem] = []
        query.collections?.forEach { returnValue.append($0.representativeItem!) }
        self.items = returnValue
    }
    
    func sectionHeaders(query: MPMediaQuery) -> [String] {
        var returnStringArray: [String] = []
        if let sections = query.collectionSections {
            for section in sections {
                returnStringArray.append(section.title)
            }
        }
        return returnStringArray
    }
}

struct MainMusicViewModel {
    let mediaDictionary: [MediaSortType: GroupCollectionProtocol]
    let player: MusicPlayer
    
    init (player: MusicPlayer) {
        self.mediaDictionary = [ MediaSortType.songs: SongsGroupCollection(query: MPMediaQuery.songs()),
                                 MediaSortType.albums: AlbumsGroupCollection(query: MPMediaQuery.albums()),
                                 MediaSortType.artists: AlbumsGroupCollection(query: MPMediaQuery.artists()),
                                 MediaSortType.playlists: SongsGroupCollection(query: MPMediaQuery.playlists()),
                                 MediaSortType.genres: AlbumsGroupCollection(query: MPMediaQuery.genres()),
                                 MediaSortType.podcasts: AlbumsGroupCollection(query: MPMediaQuery.podcasts()),
                                 MediaSortType.compilations: AlbumsGroupCollection(query: MPMediaQuery.compilations()),
                                 MediaSortType.audiobooks: AlbumsGroupCollection(query: MPMediaQuery.audiobooks())]
        self.player = player
    }
    
    func titleForSection(sortType: MediaSortType, section: Int) -> String {

            if let itemDict: GroupCollectionProtocol = self.mediaDictionary[sortType] {
                let itemSections = itemDict.sections
                if section < itemSections.count {
                    return itemSections[section].title
                }
            }
        return ""
    }
    
    func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int {
        guard let media = self.mediaDictionary[sortType] else { return 0 }
        if section < media.sections.count {
            return media.sections[section].range.length
        }
        return 0
    }
    
    func sectionIndexTitles(sortType: MediaSortType) -> [String] {
        var indexTitles: [String] = []
        if let media = self.mediaDictionary[sortType] {
            media.sections.forEach {indexTitles.append($0.title)}
        }
        return indexTitles
    }
    
    func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage {
        guard let media = mediaDictionary[sortType] else { return UIImage(named: "noteSml.png")! }
        let section = media.sections[indexPath.section]
        let index = section.range.location + indexPath.row
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSize(width: 40*imageViewModifier, height: 40*imageViewModifier)
        return media.items[index].artwork?.image(at: cellImageSize) ?? UIImage(named: "noteSml.png")!
    }
    
    func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> String {
        guard let media = mediaDictionary[sortType] else { return "" }
        let section = media.sections[indexPath.section]
        let index = section.range.location + indexPath.row
        let mediaItem = media.items[index]

        switch sortType {
        case .albums, .audiobooks, .compilations:
            return mediaItem.albumTitle ?? ""
        case .artists:
            return mediaItem.artist ?? ""
        case .genres:
            return mediaItem.genre ?? ""
        case .songs, .playlists:
            return mediaItem.title ?? ""
        case .podcasts:
            return mediaItem.podcastTitle ?? ""
        }
        
    }
    
    //    func itemAtSelectedRow(indexPath: IndexPath, sortType: MediaSortType) -> MPMediaItem {
    //
    //    }
    
    func didSelectSongAtRowAt(indexPath: IndexPath, sortType: MediaSortType) {
        
        guard let media = mediaDictionary[sortType] else { return }
        let range = media.sections[indexPath.section].range
        let item = media.items[range.location + indexPath.row]
        
        if let nowPlayingItem = player.currentSong {
            
            if (nowPlayingItem.title == item.title){
                if player.currentPlaybackState() == MPMusicPlaybackState.playing {
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
    
}
