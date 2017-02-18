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
    let mediaGroupCollection: GroupCollectionProtocol
    let sortType: MediaSortType
    
    func titleForSection(section: Int) -> String {
            let itemSectionsCount = self.mediaGroupCollection.sections.count
            if section < itemSectionsCount {
                return mediaGroupCollection.sections[section].title
            }
        return ""
    }
    
    func numberOfSections() -> Int{
        return mediaGroupCollection.sections.count
    }
    
    func numberOfRowsForSection(section: Int) -> Int {
        if section < mediaGroupCollection.sections.count {
            return mediaGroupCollection.sections[section].range.length
        }
        return 0
    }
    
    func sectionIndexTitles() -> [String] {
        var indexTitles: [String] = []
         let media = self.mediaGroupCollection
            media.sections.forEach {indexTitles.append($0.title)}
        
        return indexTitles
    }
    
    func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage {
        let media = mediaGroupCollection
        let section = media.sections[indexPath.section]
        let index = section.range.location + indexPath.row
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSize(width: 40*imageViewModifier, height: 40*imageViewModifier)
        return media.items[index].artwork?.image(at: cellImageSize) ?? UIImage(named: "noteSml.png")!
    }
    
    func cellLabelText(indexPath: IndexPath) -> String {
        let media = mediaGroupCollection
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

}
