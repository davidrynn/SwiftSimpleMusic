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
    let letter: String
    var songs: [MPMediaItem]
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
    
    
    
    fileprivate func collection(query: MPMediaQuery) -> MediaCollection {
        let items = query.items!
        return MediaCollection(items: items)
    }
    
    init (collection: MediaCollection) {
        self.collection = collection
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
            sections.append(SectionStruct(letter: letter, songs: songArray))
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
    
    //    func alphabeticalLetterHeaders() -> [Character : [MPMediaItem]] {
    //        var letters: [Character]
    //        var sectionDictionary: [String : String]
    //
    //
    //        let data = collection.items
    //        letters = data.map { (song) -> Character in
    //            if let title = song.title {
    //                return title[title.startIndex]
    //            }
    //            return Character("")
    //        }
    //
    //        letters = letters.sort()
    //
    //        letters = letters.reduce([], combine: { (list, name) -> [Character] in
    //            if !list.contains(name) {
    //                return list + [name]
    //            }
    //            return list
    //        })
    //
    //        var sections: [Character: [MediaItem]] = [:]
    //
    //        for item in data {
    //            if let title = item.title {
    //            if sections[title[title.startIndex]] == nil {
    //                sections[title[title.startIndex]] = [MPMediaItem]()
    //            }
    //
    //            sections[title[title.startIndex]]!.append(item)
    //            }
    //
    //        }
    //
    //        for (_, list) in sections {
    //
    //            list.sort {
    //                $
    //            }
    //        }
    //
    //        return sections
    //    }
    //
    //    func test() {
    //        let data = ["Anton", "Anna", "John", "Caesar"] // Example data, use your phonebook data here.
    //
    //        // Build letters array:
    //
    //        var letters: [Character]
    //
    //        letters = data.map { (name) -> Character in
    //            return name[name.startIndex]
    //        }
    //
    //        letters = letters.sort()
    //
    //        letters = letters.reduce([], combine: { (list, name) -> [Character] in
    //            if !list.contains(name) {
    //                return list + [name]
    //            }
    //            return list
    //        })
    //
    //
    //        // Build contacts array:
    //
    //        var contacts = [Character: [String]]()
    //
    //        for entry in data {
    //
    //            if contacts[entry[entry.startIndex]] == nil {
    //                contacts[entry[entry.startIndex]] = [String]()
    //            }
    //            
    //            contacts[entry[entry.startIndex]]!.append(entry)
    //            
    //        }
    //        
    //        for (_, list) in contacts {
    //            list.sort()
    //        }
    //    }
}
