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
    var firstTimeTap: Bool = true
    let subCollection: SubGroupCollection
    var items: [MPMediaItem] { return subCollection.items }
    
    
    func titleForSection(section: Int) -> String {
        let sortType = subCollection.sortType
        switch sortType {
        case .albums, .audiobooks, .compilations:
            return items[0].albumTitle ?? ""
        case .artists:
            return subCollection.collections[section].representativeItem?.albumTitle ?? ""
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
        //            let itemSectionsCount = self.mediaGroupCollection.sections.count
        //            if section < itemSectionsCount {
        //                return mediaGroupCollection.sections[section].title
        //            }
        return ""
    }
    
    func numberOfSections() -> Int{
        if subCollection.sortType == .artists {
            return subCollection.collections.count
        }
        return 1
    }

    
    func numberOfRowsForSection(section: Int) -> Int {
        if subCollection.sortType == .artists {
            return subCollection.collections[section].items.count
        }
        return items.count
    }
    
    //    func sectionIndexTitles() -> [String] {
    //        var indexTitles: [String] = []
    //         let media = self.mediaGroupCollection
    //            media.sections.forEach {indexTitles.append($0.title)}
    //
    //        return indexTitles
    //    }
    
    func cellImage(indexPath: IndexPath) -> UIImage {
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSize(width: 40*imageViewModifier, height: 40*imageViewModifier)
        return subCollection.collections[indexPath.row].items[indexPath.row].artwork?.image(at: cellImageSize) ?? UIImage(named: "noteSml.png")!
    }
    
    func cellLabelText(indexPath: IndexPath) -> String {
        let mediaItem: MPMediaItem = subCollection.collections[indexPath.section].items[indexPath.row]
        return mediaItem.title ?? ""
    }
    
    func didSelectSongAtRowAt(indexPath: IndexPath) {
        
        var item = items[indexPath.row]
        if subCollection.sortType == .artists {
         item = subCollection.collections[indexPath.section].items[indexPath.row]
        }
        if firstTimeTap {
            if subCollection.sortType == .artists {
                player.setPlayerQueue(with: subCollection.collections[indexPath.section])
            } else {
            player.setPlayerQueue(with: MPMediaItemCollection(items: items))
            }
        }
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
