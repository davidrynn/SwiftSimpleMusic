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
    var items: [MPMediaItem] = []
    var query: MPMediaQuery {
        didSet {
            var returnValue: [MPMediaItem] = []
            query.collections?.forEach { returnValue.append($0.representativeItem!) }
            items = returnValue
        }
    }
    var sections: [MPMediaQuerySection]
    
    init(){
        self.query = MPMediaQuery.albums()
        self.sections = query.collectionSections ?? []
        
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
                                 MediaSortType.albums: SongsGroupCollection(query: MPMediaQuery.albums()),
                                 MediaSortType.artists: SongsGroupCollection(query: MPMediaQuery.artists()),
                                 MediaSortType.playlists: SongsGroupCollection(query: MPMediaQuery.playlists()),
                                 MediaSortType.genres: SongsGroupCollection(query: MPMediaQuery.genres()),
                                 MediaSortType.podcasts: SongsGroupCollection(query: MPMediaQuery.podcasts()),
                                 MediaSortType.compilations: SongsGroupCollection(query: MPMediaQuery.compilations()),
                                 MediaSortType.audiobooks: SongsGroupCollection(query: MPMediaQuery.audiobooks())]
        self.player = player
    }
    
    //    func getSectionStructArray(dataCollection: MediaCollection) -> [SectionStruct] {
    //        var letters: [String]
    //        var sections: [SectionStruct] =  []
    //
    //        let data = dataCollection.items
    //        letters = data.map { (song) -> String in
    //            if let title = song.title {
    //                let char: Character = filterOutNonAlphaChar(title.characters.first!)
    //                return String(char).capitalized
    //            }
    //            return ""
    //        }
    //
    //        letters = letters.sorted()
    //
    //        letters = letters.reduce([], { (list, song) -> [String] in
    //            if !list.contains(song) {
    //                return list + [song]
    //            }
    //            return list
    //        })
    //
    //        let pound = letters.remove(at: 0)
    //        letters.append(pound)
    //
    //        for letter in letters {
    //
    //            let songArray: [MPMediaItem] = data.filter({ (song) -> Bool in
    //                if filterOutNonAlphaChar((song.title?.characters.first)!) == letter.characters.first {
    //                    return true
    //                }
    //                return false
    //            })
    //            //            ({ $0.title?.characters.first == letter.characters.first })
    //            sections.append(SectionStruct(title: letter, songs: songArray))
    //        }
    //        return sections
    //    }
    //
    //    func fullCollections() -> MusicLists {
    //        let startTime = CFAbsoluteTimeGetCurrent()
    //        let songsStruct = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.songs()))
    //        let albumsStruct = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.albums()))
    //        let artistStruct = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.artists()))
    //        let playlists = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.playlists()))
    //        let genres = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.genres()))
    //        let finalTime = CFAbsoluteTimeGetCurrent() - startTime
    //        print("Time for \(#function) is: \(finalTime)")
    //        return MusicLists(songs: songsStruct, albums: albumsStruct, artists: artistStruct, playlists: playlists, genres: genres)
    //    }
    //
    //    func timeElapsedInSecondsWhenRunningCode(operation:()->()) -> Double {
    //        let startTime = CFAbsoluteTimeGetCurrent()
    //        operation()
    //        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    //        return Double(timeElapsed)
    //    }
    //
    //    func filterOutNonAlphaChar(_ character: Character) -> Character {
    //        let charactersToRemove = CharacterSet.letters.inverted
    //        if charset(charactersToRemove, containsCharacter: character) {
    //            return Character("#") }
    //        else {
    //            return character
    //        }
    //    }
    //
    //    fileprivate func charset(_ cset:CharacterSet, containsCharacter c:Character) -> Bool {
    //        let s = String(c)
    //        let result = s.rangeOfCharacter(from: cset)
    //        return result != nil
    //    }
    
    func titleForSection(sortType: MediaSortType, section: Int) -> String {
        
        if let itemDict: SongsGroupCollection = self.mediaDictionary[sortType] {
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
        
//        switch sortType {
//            
//        case .albums:
//            
//        case .artists:
//            
//        case .audiobooks:
//        case .compilations:
//            
//        case .genres:
//        case .playlists:
//        case .podcasts:
//        case .songs:
//            if section < media.sections.count {
//                return media.sections[section].range.length
//            }
//            return 0
//        default:
//            if section < media.sections.count {
//                return media.sections[section].range.length
//            }
//            return 0
//        }
    }
    
    func sectionIndexTitles(sortType: MediaSortType) -> [String] {
        var indexTitles: [String] = []
        if let media = self.mediaDictionary[sortType] {
            media.sections.forEach {indexTitles.append($0.title)}
            //            for section in media.sections {
            //                indexTitles.append(section.title)
            //            }
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
        return media.items[index].title ?? ""
        
    }
    
    //    func itemAtSelectedRow(indexPath: IndexPath, sortType: MediaSortType) -> MPMediaItem {
    //
    //    }
    
    func didSelectRowAt(indexPath: IndexPath, sortType: MediaSortType) {
        
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
