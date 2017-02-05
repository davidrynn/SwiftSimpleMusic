//
//  MainMusicViewModel.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

struct SectionStruct {
    let title: String
    var songs: [MPMediaItem]
}

struct MediaGroupCollection {
    let query: MPMediaQuery
    let items: [MPMediaItem]
    let sections: [MPMediaQuerySection]
    
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

class MusicLists {
    let songs: [SectionStruct]
    let albums: [SectionStruct]
    let artists: [SectionStruct]
    let playlists: [SectionStruct]
    let genres: [SectionStruct]
    init(songs: [SectionStruct], albums: [SectionStruct], artists: [SectionStruct], playlists: [SectionStruct], genres: [SectionStruct]) {
        self.songs = songs
        self.albums = albums
        self.artists = artists
        self.playlists = playlists
        self.genres = genres
    }
}


struct MainMusicViewModel {
    var collection: MediaCollection!
    let mediaDictionary: [MediaSortType: MediaGroupCollection]
    
    fileprivate func collection(query: MPMediaQuery) -> MediaCollection {
        let items = query.items!
        return MediaCollection(items: items)
    }
    
    init (collection: MediaCollection) {
        self.collection = collection
        self.mediaDictionary = [ MediaSortType.songs: MediaGroupCollection(query: MPMediaQuery.songs()),
                                 MediaSortType.albums: MediaGroupCollection(query: MPMediaQuery.albums()),
                                 MediaSortType.artists: MediaGroupCollection(query: MPMediaQuery.artists()),
                                 MediaSortType.playlists: MediaGroupCollection(query: MPMediaQuery.playlists()),
                                 MediaSortType.genres: MediaGroupCollection(query: MPMediaQuery.genres()),
                                 MediaSortType.podcasts: MediaGroupCollection(query: MPMediaQuery.podcasts()),
                                 MediaSortType.compilations: MediaGroupCollection(query: MPMediaQuery.compilations()),
                                 MediaSortType.audiobooks: MediaGroupCollection(query: MPMediaQuery.audiobooks())]
    }
    
    func getSectionStructArray(dataCollection: MediaCollection) -> [SectionStruct] {
        var letters: [String]
        var sections: [SectionStruct] =  []
        
        let data = dataCollection.items
        letters = data.map { (song) -> String in
            if let title = song.title {
                let char: Character = filterOutNonAlphaChar(title.characters.first!)
                return String(char).capitalized
            }
            return ""
        }
        
        letters = letters.sorted()
        
        letters = letters.reduce([], { (list, song) -> [String] in
            if !list.contains(song) {
                return list + [song]
            }
            return list
        })
        
        let pound = letters.remove(at: 0)
        letters.append(pound)
        
        for letter in letters {
            
            let songArray: [MPMediaItem] = data.filter({ (song) -> Bool in
                if filterOutNonAlphaChar((song.title?.characters.first)!) == letter.characters.first {
                    return true
                }
                return false
            })
            //            ({ $0.title?.characters.first == letter.characters.first })
            sections.append(SectionStruct(title: letter, songs: songArray))
        }
        return sections
    }
    
    func fullCollections() -> MusicLists {
        let startTime = CFAbsoluteTimeGetCurrent()
        let songsStruct = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.songs()))
        let albumsStruct = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.albums()))
        let artistStruct = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.artists()))
        let playlists = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.playlists()))
        let genres = getSectionStructArray(dataCollection: collection(query: MPMediaQuery.genres()))
        let finalTime = CFAbsoluteTimeGetCurrent() - startTime
        print("Time for \(#function) is: \(finalTime)")
        return MusicLists(songs: songsStruct, albums: albumsStruct, artists: artistStruct, playlists: playlists, genres: genres)
    }
    
    func timeElapsedInSecondsWhenRunningCode(operation:()->()) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return Double(timeElapsed)
    }
    
    func filterOutNonAlphaChar(_ character: Character) -> Character {
        let charactersToRemove = CharacterSet.letters.inverted
        if charset(charactersToRemove, containsCharacter: character) {
            return Character("#") }
        else {
            return character
        }
    }
    
    fileprivate func charset(_ cset:CharacterSet, containsCharacter c:Character) -> Bool {
        let s = String(c)
        let result = s.rangeOfCharacter(from: cset)
        return result != nil
    }
    
    func titleForSection(sortType: MediaSortType, section: Int) -> String {
        
        if let itemDict: MediaGroupCollection = self.mediaDictionary[sortType] {
            let itemSections = itemDict.sections
            if section < itemSections.count {
                return itemSections[section].title
            }
        }
        return ""
    }
    
    func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int {
        if let media = self.mediaDictionary[sortType] {
            return media.sections[section].range.length
        }
        return 0
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
    
}
