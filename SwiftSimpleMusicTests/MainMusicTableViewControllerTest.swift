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

@MainActor
class MainMusicTableViewControllerTest: XCTestCase {
    var sut: MainMusicTableViewController!
    
    override func setUp() async throws {
        try await super.setUp()
        // Storyboard lives in the app bundle, not the test bundle.
        let storyboard = UIStoryboard(name: "Storyboard",
                                      bundle: Bundle(for: TopViewController.self))
        let topViewController = storyboard.instantiateInitialViewController() as! TopViewController
        // Loading the view fires the embed segue, which captures the main VC (no injection yet).
        topViewController.loadViewIfNeeded()
        sut = topViewController.mainMusicVC
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
        var mediaDictionary: [MediaSortType: GroupCollectionProtocol] { return [:] }

        func togglePlaying(item: MPMediaItem) {}
        func togglePlayingSelectedSong() {}
        func numberOfSections(sortType: MediaSortType) -> Int { return 1 }
        func titleForSection(sortType: MediaSortType, section: Int) -> String { return "A" }
        func numberOfRowsForSection(sortType: MediaSortType, section: Int) -> Int { return 0 }
        func sectionIndexTitles(sortType: MediaSortType) -> [String] { return [] }
        func cellImage(sortType: MediaSortType, indexPath: IndexPath) -> UIImage { return UIImage() }
        func cellLabelText(sortType: MediaSortType, indexPath: IndexPath) -> (title: String?, detail: String?)? { return nil }
        func didSelectSongAtRowAt(indexPath: IndexPath, sortType: MediaSortType) {}
        func getSong(sortType: MediaSortType, indexPath: IndexPath) -> MPMediaItem? { return nil }
        func getSubViewModelFromSearch(section: SearchSection, indexPath: IndexPath) -> MediaViewModel { fatalError("Not implemented") }
        func getSubViewModel(sortType: MediaSortType, item: MPMediaItem) -> MediaViewModel { fatalError("Not implemented") }
        func getSubViewModelFromSelectedRow(sortType: MediaSortType) -> MediaViewModel { fatalError("Not implemented") }
        func setPlayerQueue(sortType: MediaSortType) {}
        mutating func setSelectedItem(sortType: MediaSortType, indexPath: IndexPath) {}
        func playFilteredSong(indexPath: IndexPath) {}
        mutating func searchMedia(searchText: String) {}
    }
}
