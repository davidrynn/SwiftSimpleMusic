//
//  MediaCollection.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/11/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation
import MediaPlayer

struct MediaCollection {
    
    init (items: [MPMediaItem]) {
        self.mpMediaCollection = MPMediaItemCollection(items: items)
        self.items = items
        self.representativeItem = self.mpMediaCollection.representativeItem
        self.count = self.mpMediaCollection.count
        self.mediaTypes = self.mpMediaCollection.mediaTypes
    }
    
    private var mpMediaCollection: MPMediaItemCollection


    var items: [MPMediaItem]
    
    // Returns an item representative of other items in the collection.
    // This item can be used for common item properties in the collection, often more efficiently than fetching an item out of the items array.
    var representativeItem: MPMediaItem?
    // Returns the number of items in the collection.
    // In some cases, this is more efficient than fetching the items array and asking for the count.
    var count: Int
    
    // Returns the types of media which the collection holds.
   var mediaTypes: MPMediaType
    
}
