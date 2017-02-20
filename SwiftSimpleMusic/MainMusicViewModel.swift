//
//  MainMusicViewModel.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

protocol MainMusicViewModelProtocol {
    var mediaDictionary: [MediaSortType : GroupCollectionProtocol] { get }
    var player: MusicPlayerProtocol { get }
    func numberOfSections(sortType: MediaSortType) -> Int
    func titleForSection(sortType: MediaSortType, section: Int) -> String
    func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int
    func sectionIndexTitles(sortType: MediaSortType) -> [String]
    func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage
    func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> String
    func didSelectSongAtRowAt(indexPath: IndexPath, sortType: MediaSortType)
    func getSubViewModel(sortType: MediaSortType, indexPath: IndexPath) -> MediaViewModel
}

protocol GroupCollectionProtocol {

    var items: [MPMediaItem] { get set }
    var collections: [MPMediaItemCollection] { get set }
    var query: MPMediaQuery { get }
    var sections: [MPMediaQuerySection] { get set }
    func sectionHeaders() -> [String]
}

struct SongsGroupCollection: GroupCollectionProtocol {
    
    var query: MPMediaQuery
    var items: [MPMediaItem]
    var collections: [MPMediaItemCollection]
    var sections: [MPMediaQuerySection]
    
    init() {
        self.query = MPMediaQuery.songs()
        self.items = query.items ?? []
        self.collections = query.collections ?? []
        self.sections = query.itemSections ?? []
    }
    
    func sectionHeaders() -> [String] {
        var returnStringArray: [String] = []
        if let sections = query.itemSections {
            for section in sections {
                returnStringArray.append(section.title)
            }
        }
        return returnStringArray
    }
}

struct GroupCollection: GroupCollectionProtocol {
    var items: [MPMediaItem]
    var collections: [MPMediaItemCollection]
    var query: MPMediaQuery
    var sections: [MPMediaQuerySection]
    
    init(query: MPMediaQuery){
        self.query = query
        self.sections = query.collectionSections ?? []
        self.items = query.items ?? []
        self.collections = query.collections ?? []
    }
  
    func sectionHeaders() -> [String] {
        var returnStringArray: [String] = []
        if let sections = query.collectionSections {
            for section in sections {
                returnStringArray.append(section.title)
            }
        }
        return returnStringArray
    }
}

struct SubGroupCollection: GroupCollectionProtocol {
    var items: [MPMediaItem]
    var collections: [MPMediaItemCollection]
    var query: MPMediaQuery
    var sections: [MPMediaQuerySection]
    
    init(items: [MPMediaItem], collections: [MPMediaItemCollection], query: MPMediaQuery, sections: [MPMediaQuerySection]){
        self.query = query
        self.sections = sections
        self.items = items
        self.collections = collections
    }
    
    func sectionHeaders() -> [String] {
        var returnStringArray: [String] = []
        if let sections = query.collectionSections {
            for section in sections {
                returnStringArray.append(section.title)
            }
        }
        return returnStringArray
    }
}


struct MainMusicViewModel: MainMusicViewModelProtocol {
    var mediaDictionary: [MediaSortType : GroupCollectionProtocol]
    var player: MusicPlayerProtocol
    
    init (player: MusicPlayerProtocol) {
        self.mediaDictionary = [ MediaSortType.songs: SongsGroupCollection(),
                                 MediaSortType.albums: GroupCollection(query: MPMediaQuery.albums()),
                                 MediaSortType.artists: GroupCollection(query: MPMediaQuery.artists()),
                                 MediaSortType.playlists: GroupCollection(query: MPMediaQuery.playlists()),
                                 MediaSortType.genres: GroupCollection(query: MPMediaQuery.genres()),
                                 MediaSortType.podcasts: GroupCollection(query: MPMediaQuery.podcasts()),
                                 MediaSortType.compilations: GroupCollection(query: MPMediaQuery.compilations()),
                                 MediaSortType.audiobooks: GroupCollection(query: MPMediaQuery.audiobooks())]
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

    func numberOfSections(sortType: MediaSortType) -> Int{
        guard let sortedGrouping = mediaDictionary[sortType] else { return 0 }
        if sortType == .playlists { return 1 }
        return sortedGrouping.sections.count
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
        let mediaItem: MPMediaItem = media.items[index]
        let mediaCollection: MPMediaItemCollection = media.collections[index]


        switch sortType {
        case .albums, .audiobooks, .compilations:
            return mediaCollection.representativeItem?.albumTitle ?? ""
        case .artists:
            return mediaCollection.representativeItem?.artist ?? ""
        case .genres:
            return mediaCollection.representativeItem?.genre ?? ""
        case .songs:
            return mediaItem.title ?? ""
        case .playlists:
            guard let playlist = mediaCollection as? MPMediaPlaylist else { return "" }
            return playlist.name ?? ""
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
    
    func getSubViewModel(sortType: MediaSortType, indexPath: IndexPath) -> MediaViewModel  {
        let collectionItems = mediaDictionary[sortType]?.collections[indexPath.row]
//        let subGroup = SubGroupCollection(items: <#T##[MPMediaItem]#>, collections: <#T##[MPMediaItemCollection]#>, query: <#T##MPMediaQuery#>, sections: <#T##[MPMediaQuerySection]#>)
        return MediaViewModel(sortType: sortType, items: collectionItems?.items ?? [], player: player, firstTimeTap: true )
    }
    
}

