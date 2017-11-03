//
//  InjectableObjects.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/11/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer


struct InjectionObjects {
    let player: MusicPlayerProtocol
    let collection: MediaCollection
    
    init (player: MusicPlayerProtocol, collection: MediaCollection) {
        self.player = player
        self.collection = collection
    }
}
