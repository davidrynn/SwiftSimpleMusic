//
//  MainMusicViewModelTest.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import XCTest
@testable import SwiftSimpleMusic
import MediaPlayer

class MainMusicViewModelTest: XCTestCase {
    
    struct testMediaItem: MediaItemProtocol {
        var title: String?
        var artwork: MPMediaItemArtwork?
        
    }

    override func setUp() {
        super.setUp()
        let song1: MediaItemProtocol = testMediaItem(title: "Albert", artwork: nil)
        let song2: MediaItemProtocol = testMediaItem(title: "Ahaaa", artwork: nil)
//        let sectionHeader1: SectionHeaderInfo = SectionHeaderInfo(letter: "A", song: <#T##MPMediaItem#>)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
