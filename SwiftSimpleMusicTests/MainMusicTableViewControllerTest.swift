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
        let bogusFilteredMedia = FilteredMedia(songs: [], albums: [], artists: [])
        sut.viewModel = MockMainMusicTableViewModel(appState: .normal, filteredMedia: bogusFilteredMedia)
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
        var appState: AppState
        
        var filteredMedia: FilteredMedia
        
        func togglePlaying(item: MPMediaItem) {
            
        }
        
        func togglePlayingSelectedSong() {
            
        }
        
        func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> (title: String?, detail: String?)? {
            
        }
        
        func getSong(sortType: MediaSortType, indexPath: IndexPath) -> MPMediaItem? {
            <#code#>
        }
        
        func getSubViewModelFromSearch(section: SearchSection, indexPath: IndexPath) -> MediaViewModel {
            <#code#>
        }
        
        func getSubViewModel(sortType: MediaSortType, item: MPMediaItem) -> MediaViewModel {
            <#code#>
        }
        
        func getSubViewModelFromSelectedRow(sortType: MediaSortType) -> MediaViewModel {
            <#code#>
        }
        
        mutating func setSelectedItem(sortType: MediaSortType, indexPath: IndexPath) {
            <#code#>
        }
        
        func playFilteredSong(indexPath: IndexPath) {
            <#code#>
        }
        
        mutating func searchMedia(searchText: String) {
            <#code#>
        }
        
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
        
//        func getSubViewModel(sortType: MediaSortType,  indexPath: IndexPath) -> MediaViewModel {
//            let groupsStruct = GroupCollection(query: mediaDictionary)
//            return MediaViewModel(player: player, sortType: sortType, groupStruct: mediaDictionary[sortType]?.items ?? [], firstTimeTap: true)
//        }
        
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
