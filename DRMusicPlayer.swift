////
////  DRMusicPlayer.swift
////  SwiftSimpleMusic
////
////  Created by David Rynn on 11/25/15.
////  Copyright © 2015 David Rynn. All rights reserved.
////
//
//import Foundation
//
//class NSArray (DRArray) {
//    var (nonatomic, readonly, copy) shuffledArray
//    DRShuffledArray: DRArray
//    - (NSArray *)shuffled {
//    //altered from original
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
//    NSUInteger count = [mutableArray count];
//    // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
//    if (count > 1) {
//    for (NSUInteger i = count - 1; i > 0; --i) {
//    [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
//    }
//    }
//    
//    NSArray *randomArray = [NSArray arrayWithArray:mutableArray];
//    
//    return randomArray;
//    }
//}
//
//class DRMusicPlayer: NSObject {
//
//}
