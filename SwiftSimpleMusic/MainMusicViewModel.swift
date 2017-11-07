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
    var appState: AppState { get set }
    var filteredMedia: FilteredMedia { get }
    func togglePlaying(item: MPMediaItem)
    func numberOfSections(sortType: MediaSortType) -> Int
    func titleForSection(sortType: MediaSortType, section: Int) -> String
    func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int
    func sectionIndexTitles(sortType: MediaSortType) -> [String]
    func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage
    func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> (title: String?, detail: String?)?
    func didSelectSongAtRowAt(indexPath: IndexPath, sortType: MediaSortType)
    func getSong(sortType: MediaSortType, indexPath: IndexPath) -> MPMediaItem?
    func getSubViewModelFromSearch(section: SearchSection, indexPath: IndexPath) -> MediaViewModel
    func getSubViewModel(sortType: MediaSortType, indexPath: IndexPath) -> MediaViewModel
    func getSubViewModel(sortType: MediaSortType, item: MPMediaItem) -> MediaViewModel
    func setPlayerQueue(sortType: MediaSortType)
    func playFilteredSong(indexPath: IndexPath)
    mutating func searchMedia(searchText: String)
}

struct FilteredMedia {
    var songs: [MPMediaItem]
    var albums: [MPMediaItemCollection]
    var artists: [MPMediaItemCollection]
}

protocol GroupCollectionProtocol {
    
    var items: [MPMediaItem] { get set }
    var collections: [MPMediaItemCollection] { get set }
    var sections: [MPMediaQuerySection] { get set }
    func sectionHeaders() -> [String]
}

struct SubGroupCollection: GroupCollectionProtocol {
    var items: [MPMediaItem]
    var collections: [MPMediaItemCollection]
    var sections: [MPMediaQuerySection]
    var sortType: MediaSortType
    
    func sectionHeaders() -> [String] {
        var returnStringArray: [String] = []
        for section in sections {
            returnStringArray.append(section.title)
        }
        return returnStringArray
    }
}

struct SearchCollection: GroupCollectionProtocol {
    var items: [MPMediaItem]
    var collections: [MPMediaItemCollection]
    var sections: [MPMediaQuerySection]
    
    func sectionHeaders() -> [String] {
        return ["Songs", "Artists", "Albums"]
    }
    
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

struct MainMusicViewModel: MainMusicViewModelProtocol {
    
    var mediaDictionary: [MediaSortType : GroupCollectionProtocol]
    var player: MusicPlayerProtocol
    var appState: AppState = .normal
    var filteredMedia: FilteredMedia
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
        self.filteredMedia = FilteredMedia(songs: [], albums: [], artists: [])
    }
    
    func titleForSection(sortType: MediaSortType, section: Int) -> String {
        if appState == .isSearching {
            let sectionsArr = ["Songs", "Albums", "Artists"]
            return sectionsArr[section]
        } else {
            
            if let itemDict: GroupCollectionProtocol = self.mediaDictionary[sortType] {
                let itemSections = itemDict.sections
                if section < itemSections.count {
                    return itemSections[section].title
                }
            }
            return ""
        }
    }
    
    func numberOfSections(sortType: MediaSortType) -> Int{
        if appState == .isSearching {
            return 3
        } else {
            guard let sortedGrouping = mediaDictionary[sortType] else { return 0 }
            if sortType == .playlists { return 1 }
            return sortedGrouping.sections.count
        }
    }
    func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int {
        if appState == .isSearching {
            switch section {
            case 0:
                return filteredMedia.songs.count
            case 1:
                return filteredMedia.albums.count
            case 2:
                return filteredMedia.artists.count
            default:
                return 0
            }
        } else {
            guard let media = self.mediaDictionary[sortType] else { return 0 }
            if section < media.sections.count {
                return media.sections[section].range.length
            }
            
            return 0
        }
    }
    
    func sectionIndexTitles(sortType: MediaSortType) -> [String] {
        if appState == .isSearching {
            return []
        } else{
            var indexTitles: [String] = []
            if let media = self.mediaDictionary[sortType] {
                media.sections.forEach {indexTitles.append($0.title)}
            }
            return indexTitles
        }
    }
    
    func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage {
        
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSize(width: 20, height: 20)
        guard let defaultImage: UIImage = UIImage(named: "noteSml.png") else { return UIImage() }
        
        if appState == .isSearching {
            switch indexPath.section {
            case 0:
                return filteredMedia.songs[indexPath.row].artwork?.image(at: cellImageSize) ?? defaultImage
            case 1:
                return filteredMedia.albums[indexPath.row].representativeItem?.artwork?.image(at: cellImageSize) ?? defaultImage
            case 2:
                return filteredMedia.artists[indexPath.row].representativeItem?.artwork?.image(at: cellImageSize) ?? defaultImage
            default:
                return defaultImage
            }
        } else {
            guard let media = mediaDictionary[sortType] else { return UIImage(named: "noteSml.png")! }
            let section = media.sections[indexPath.section]
            let index = section.range.location + indexPath.row
            
            
            if sortType == .songs {
                let mediaItem: MPMediaItem = media.items[index]
                return mediaItem.artwork?.image(at: cellImageSize) ?? defaultImage
                
            } else {
                let collection = media.collections[index]
                return collection.representativeItem?.artwork?.image(at: cellImageSize) ?? defaultImage
            }
        }
    }
    
    func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> (title: String?, detail: String?)? {
        guard let media = mediaDictionary[sortType] else { return ("","") }
        let section = media.sections[indexPath.section]
        let index = section.range.location + indexPath.row
        let mediaItem: MPMediaItem = media.items[index]
        let mediaCollection: MPMediaItemCollection = media.collections[index]
        
        //handle search
        if appState == .isSearching {
            switch indexPath.section {
            case 0:
                let song: MPMediaItem = filteredMedia.songs[indexPath.row]
                return (song.title, ((song.artist ?? "Unknown Artist") + "--" + (song.albumTitle ?? "Unknown Album")))
            case 1:
                let album = filteredMedia.albums[indexPath.row]
                return (album.representativeItem?.albumTitle, album.representativeItem?.artist)
            case 2:
                let artist = filteredMedia.artists[indexPath.row]
                return (artist.representativeItem?.artist, "")
            default:
                return ("","")
            }
        }
        
        switch sortType {
        case .albums, .audiobooks, .compilations:
            return (mediaCollection.representativeItem?.albumTitle, mediaCollection.representativeItem?.artist)
        case .artists:
            return (mediaCollection.representativeItem?.artist, "")
        case .genres:
            return (mediaCollection.representativeItem?.genre, "")
        case .songs:
            let song: MPMediaItem = mediaItem
            return (song.title, ((song.artist ?? "Unknown Artist") + "--" + (song.albumTitle ?? "Unknown Album")))
        case .playlists:
            guard let playlist = mediaCollection as? MPMediaPlaylist else { return ("","") }
            return (playlist.name, "")
        case .podcasts:
            return (mediaItem.podcastTitle, "")
        }
        
    }
    
    //    func itemAtSelectedRow(indexPath: IndexPath, sortType: MediaSortType) -> MPMediaItem {
    //
    //    }
    
    func didSelectSongAtRowAt(indexPath: IndexPath, sortType: MediaSortType) {
        //should only work for songs
        if appState == .isSearching {
            switch indexPath.section {
            case 0:
                let item = filteredMedia.songs[indexPath.row]
                togglePlaying(item: item)
            default:
                return
            }
            
            return }
        if sortType == .songs {
            guard let item = getSong(sortType: sortType, indexPath: indexPath) else { return }
            togglePlaying(item: item)
        }
    }
    
    func togglePlaying(item: MPMediaItem){
        if let nowPlayingItem = player.currentSong {
            
            if (nowPlayingItem.title == item.title){
                if player.currentPlaybackState() == MPMusicPlaybackState.playing {
                    player.pause()
                } else {
                    player.playItem(item)
                }
                
            } else {
                player.playItem(item)
            }
        } else {
            player.playItem(item)
        }
    }
    
    func getSubViewModelFromSearch(section: SearchSection, indexPath: IndexPath) -> MediaViewModel {
        let filteredItems = (section == .albums) ? filteredMedia.albums[indexPath.row].items : filteredMedia.artists[indexPath.row].items
        let filteredCollection = (section == .albums) ? filteredMedia.albums[indexPath.row] : filteredMedia.artists[indexPath.row]
        let collection = SearchCollection(items: filteredItems, collections: [filteredCollection], sections: [])
        return MediaViewModel(player: player, sortType: section.sortType(), groupStruct: collection, firstTimeTap: true)
    }
    
    func getSubViewModel(sortType: MediaSortType, item: MPMediaItem) -> MediaViewModel {
        var collections: [MPMediaItemCollection] = []
        var items: [MPMediaItem] = []
        var groupCollection: GroupCollectionProtocol?
        
        if sortType == .albums {
            let album = item.albumTitle
            let query = MPMediaQuery.albums()
            let predicate = MPMediaPropertyPredicate(value: album, forProperty: "albumTitle")
            query.addFilterPredicate(predicate)
            query.groupingType = .album
            groupCollection = GroupCollection(query: query)
//            collections = query.collections ?? []
//            items = query.items ?? []
        }
        else if sortType == .artists {
            let artist = item.artist
            let query = MPMediaQuery.artists()
            let predicate = MPMediaPropertyPredicate(value: artist, forProperty: "artist")
            query.addFilterPredicate(predicate)
            query.groupingType = .artist
            groupCollection = GroupCollection(query: query)

        }
        guard let grouping = groupCollection else { fatalError() }
        return MediaViewModel(player: player, sortType: sortType, groupStruct: grouping, firstTimeTap: true )
    
    }

    
    func getSubViewModel(sortType: MediaSortType, indexPath: IndexPath) -> MediaViewModel  {
        
        guard let media = mediaDictionary[sortType] else { fatalError("failed at line 219 \(#function)") }
        let range = media.sections[indexPath.section].range
        
        let start = range.location
        //        let end = range.location + range.length
        var collections = [media.collections[start + indexPath.row]]
        let collectionItems = collections[0].items
        var subGrouping: GroupCollectionProtocol = SubGroupCollection(items: collectionItems, collections: collections, sections: [], sortType: sortType)
        if sortType == .artists {
            let artistPredicate = MPMediaPropertyPredicate.init(value: collectionItems[0].artist, forProperty: MPMediaItemPropertyArtist)
            let query = MPMediaQuery.albums()
            query.addFilterPredicate(artistPredicate)
            query.groupingType = .album
            subGrouping = GroupCollection(query: query)
        }
        return MediaViewModel(player: player, sortType: sortType, groupStruct: subGrouping, firstTimeTap: true)
    }
    
    func setPlayerQueue(sortType: MediaSortType) {
        //to make sure correct queue is setup when returning from subview
        var query:MPMediaQuery
        switch sortType {
        case .albums:
            query = MPMediaQuery.albums()
        case .audiobooks:
            query = MPMediaQuery.audiobooks()
        case .compilations:
            query = MPMediaQuery.compilations()
        case .artists:
            query = .artists()
        case .genres:
            query = .genres()
        case .songs:
            query = .songs()
        case .playlists:
            query = .playlists()
        case .podcasts:
            query = .podcasts()
        }
        player.setPlayerQueue(with: query)
    }
    
    func playFilteredSong(indexPath: IndexPath) {
        togglePlaying(item: filteredMedia.songs[indexPath.row])
    }
    
    func getSong(sortType: MediaSortType, indexPath: IndexPath) -> MPMediaItem? {
        guard let media = mediaDictionary[sortType] else { return nil }
        let section = media.sections[indexPath.section]
        let index = section.range.location + indexPath.row
        let mediaCollection: MPMediaItemCollection = media.collections[index]
        if sortType == .songs {
         return media.items[index]
        }
        return mediaCollection.representativeItem
    }
    
    mutating func searchMedia(searchText: String){
        if searchText.isEmpty { return }
        appState = .isSearching
        let songs = mediaDictionary[.songs]?.items ?? []
        filteredMedia.songs = searchText.isEmpty ? [] : songs.filter({(item: MPMediaItem) -> Bool in
            return item.title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        let albums = mediaDictionary[.albums]?.collections ?? []
        filteredMedia.albums = searchText.isEmpty ? [] : albums.filter({(item: MPMediaItemCollection) -> Bool in
            return item.representativeItem?.albumTitle?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        let artists = mediaDictionary[.artists]?.collections ?? []
        filteredMedia.artists = searchText.isEmpty ? [] : artists.filter({(item: MPMediaItemCollection) -> Bool in
            return item.representativeItem?.artist?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
    }
    
}

