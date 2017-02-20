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
    let sortType: MediaSortType
    let items: [MPMediaItem]
    let player: MusicPlayerProtocol
    var firstTimeTap: Bool = true
    
    func titleForSection(section: Int) -> String {
        switch sortType {
        case .albums, .audiobooks, .compilations:
            return items[0].albumTitle ?? ""
        case .artists:
            return items[0].artist ?? ""
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
        return 1
    }
    
    func numberOfRowsForSection(section: Int) -> Int {
        //        if section < mediaGroupCollection.sections.count {
        //            return mediaGroupCollection.sections[section].range.length
        //        }
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
        return items[indexPath.row].artwork?.image(at: cellImageSize) ?? UIImage(named: "noteSml.png")!
    }
    
    func cellLabelText(indexPath: IndexPath) -> String {
        let mediaItem: MPMediaItem = items[indexPath.row]
        return mediaItem.title ?? ""
    }
    
    func didSelectSongAtRowAt(indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        if firstTimeTap {
            player.setPlayerQueue(with: MPMediaItemCollection(items: items))
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
