//
//  MainMusicTableViewControllerTest.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/5/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import XCTest
import MediaPlayer
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
        var player: MusicPlayerProtocol { return MusicPlayer() }
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
        
        func setPlayerQueue(with: MPMediaQuery) {
        }
        
        func setPlayerQueue(sortType: MediaSortType) {
        }
        
        func getSubViewModel(sortType: MediaSortType,  indexPath: IndexPath) -> MediaViewModel {
            return MediaViewModel(sortType: sortType, items: mediaDictionary[sortType]?.items ?? [], player: player, firstTimeTap: true)
        }
        
        func numberOfSections(sortType: MediaSortType) -> Int {
            return 1
        }
//        var mediaDictionary: [MediaSortType : GroupCollectionProtocol] { get }
//        var player: MusicPlayerProtocol { get }
//        func numberOfSections(sortType: MediaSortType) -> Int
//        func titleForSection(sortType: MediaSortType, section: Int) -> String
//        func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int
//        func sectionIndexTitles(sortType: MediaSortType) -> [String]
//        func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage
//        func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> String
//        func didSelectSongAtRowAt(indexPath: IndexPath, sortType: MediaSortType)
//        func getSubViewModel(sortType: MediaSortType, indexPath: IndexPath) -> MediaViewModel
//        func setPlayerQueue(sortType: MediaSortType)

    }
}
