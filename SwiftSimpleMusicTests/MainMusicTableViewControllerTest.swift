//
//  MainMusicTableViewControllerTest.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/5/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import XCTest
@testable import SwiftSimpleMusic

class MainMusicTableViewControllerTest: XCTestCase {
    var sut: MainMusicTableViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle(for: type(of: self)))
        let topViewController = storyboard.instantiateInitialViewController() as! TopViewController
        let player = MusicPlayer()
        sut = topViewController.container
        sut.inject(player)
        sut.viewModel = MockMainMusicTableViewModel()
        let _ = sut.view
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

extension MainMusicTableViewControllerTest {
    struct MockMainMusicTableViewModel: MainMusicViewModelProtocol {
        var mediaDictionary: [MediaSortType : GroupCollectionProtocol] { return [ : ] }
        var player: MusicPlayer { return MusicPlayer() }
        func titleForSection(sortType: MediaSortType, section: Int) -> String {
            return "A"
        }
        func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int {
            return 0
        }
        func sectionIndexTitles(sortType: MediaSortType) -> [String] {
      //      return Array(NSSeyt)
            return []
        }
        func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage {
            return UIImage()
        }
        func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> String
        {
            let returnString = "zed"
            return returnString
        }
        func didSelectSongAtRowAt(indexPath: IndexPath, sortType: MediaSortType) {
        }
    }
}
