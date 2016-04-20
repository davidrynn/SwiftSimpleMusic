//
//  MusicPlayer.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

struct MusicPlayer {
    
    var currentSong: MPMediaItem
    var nextSong: MPMediaItem
    var previousSong: MPMediaItem
    var musicCollection: MPMediaItemCollection
    var randomizedCollection: MPMediaItemCollection
    

func play() {
    
}

func stop() {
    
}

func pause() {
    
}

func forward() {
    //fast forward on long press
    //next on one press
}

func rewind() {
    //rewind on long press
    //to beginning of song on one press
    //to previous on double tap
}

    
}