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
    
    // Storyboard lives in the app bundle, not the test bundle.
    private var storyboard: UIStoryboard {
        UIStoryboard(name: "Storyboard", bundle: Bundle(for: TopViewController.self))
    }
    
    override func setUp() async throws {
        try await super.setUp()
        // Instantiate the list on its own so tests control when dependencies arrive,
        // rather than racing TopViewController's real MusicPlayer load.
        sut = storyboard.instantiateViewController(withIdentifier: "MainMusicTableViewController") as? MainMusicTableViewController
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - TopViewController wiring
    
    func testTopViewControllerLoad_CapturesMainMusicViewControllerWithoutInjecting() throws {
        let topViewController = try XCTUnwrap(storyboard.instantiateInitialViewController() as? TopViewController)
        // Loading the view fires the embed segue synchronously; the player loads later.
        topViewController.loadViewIfNeeded()
        let mainVC = try XCTUnwrap(topViewController.mainMusicVC)
        XCTAssertNil(mainVC.viewModel)
    }
    
    // MARK: - Before injection
    
    func testBeforeInjection_TableIsEmpty() {
        sut.loadViewIfNeeded()
        XCTAssertNil(sut.viewModel)
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), 0)
        XCTAssertNil(sut.sectionIndexTitles(for: sut.tableView))
    }
    
    func testBeforeInjection_ControlsAreDisabled() {
        sut.loadViewIfNeeded()
        assertControlsEnabled(false)
    }
    
    // MARK: - Injection
    
    func testInjectAfterViewLoads_ReloadsTableAndEnablesControls() {
        sut.loadViewIfNeeded()
        sut.inject(makeDependencies())
        XCTAssertNotNil(sut.viewModel)
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), 1)
        XCTAssertEqual(sut.tableView(sut.tableView, titleForHeaderInSection: 0), "A")
        assertControlsEnabled(true)
    }
    
    func testInjectBeforeViewLoads_AppliesWhenViewLoads() {
        sut.inject(makeDependencies())
        XCTAssertFalse(sut.isViewLoaded, "inject should not force the view to load")
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), 1)
        assertControlsEnabled(true)
    }
    
    // MARK: - Helpers
    
    private func makeDependencies() -> MainMusicDependencies {
        let filteredMedia = FilteredMedia(songs: [], albums: [], artists: [])
        return MainMusicDependencies(player: MockMusicPlayer(),
                                     viewModel: MockMainMusicTableViewModel(appState: .normal, filteredMedia: filteredMedia))
    }
    
    private func assertControlsEnabled(_ enabled: Bool, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.shuffleButton.isEnabled, enabled, "shuffle", file: file, line: line)
        XCTAssertEqual(sut.loopButton.isEnabled, enabled, "loop", file: file, line: line)
        let sortButton = sut.navigationItem.titleView?.subviews.first as? UIButton
        XCTAssertNotNil(sortButton, file: file, line: line)
        XCTAssertEqual(sortButton?.isEnabled, enabled, "sort", file: file, line: line)
        XCTAssertEqual(sut.searchController.searchBar.isUserInteractionEnabled, enabled, "search", file: file, line: line)
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
