//
//  MediaItem.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

protocol MediaItemProtocol {
    var title: String? { get }
    var artwork: MPMediaItemArtwork? { get }
}

struct MediaItem: MediaItemProtocol {
    let song: MPMediaItem
    let title: String?
    let artwork: MPMediaItemArtwork?
    
    init(song: MPMediaItem) {
        self.song = song
        self.title = song.title ?? ""
        self.artwork = song.artwork ?? nil
    }
}