//
//  MediaViewModelTest.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/19/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import XCTest
@testable import SwiftSimpleMusic
import MediaPlayer

class MediaViewModelTest: XCTestCase {
    
    var sut: MediaViewModel!
    
    override func setUp() {
        super.setUp()
        let query = MPMediaQuery.albums()
        let collections = query.collections
        let items = query.items
        sut = MediaViewModel(player: MusicPlayer(), sortType: .albums, firstTimeTap: true, collections: collections!, items: items!)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMediaViewModel_ShouldInitializeProperly() {
        XCTAssert(sut != nil)
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
