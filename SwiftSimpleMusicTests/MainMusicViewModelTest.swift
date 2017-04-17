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
    
    var sut: MainMusicViewModel!
    
    override func setUp() {
        super.setUp()
        let player = MusicPlayer()
        self.sut = SwiftSimpleMusic.MainMusicViewModel(player: player)
        //        let sectionHeader1: SectionHeaderInfo = SectionHeaderInfo(letter: "A", song: <#T##MPMediaItem#>)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTitleForSection_ShouldReturnLetter(){
        let title = sut.titleForSection(sortType: MediaSortType.songs, section: 0)
        XCTAssertEqual(title, "A")
        print(title)
        let title2 = sut.titleForSection(sortType: MediaSortType.songs, section: 25)
        XCTAssertEqual(title2, "Z")
        print("second title: \(title2)")
    }
    
    func testNumberOfRowsForSection_ShouldReturnCorrectInt(){
        let section = 1
        if let itemSections = MPMediaQuery.songs().itemSections {
            let itemSection = itemSections[section]
            let correctNumber: Int = itemSection.range.length
            let vmNumber = sut.numberOfRowsForSection(sortType: MediaSortType.songs, section: section)
            
            XCTAssertEqual(vmNumber, correctNumber)
            
        }
    }
    
    func testSectionIndexTitles_ShouldReturnAllIndexTitles(){
        var titles: [String] = []
        if let sections = MPMediaQuery.songs().itemSections {
            for section in sections {
                titles.append(section.title)
            }
        }
        
        let sutTitles = sut.sectionIndexTitles(sortType: MediaSortType.songs)
        XCTAssertEqual(sutTitles, titles)
        XCTAssertEqual(sutTitles[25], "Z")
    }
    
    func testCellImage_ShouldReturnProperImage(){
                let mockIndexPath = IndexPath(row: 1, section: 0)
        guard let mediaSongs = MPMediaQuery.songs().items else { fatalError("error loading songs") }
            let song = mediaSongs[mockIndexPath.row]
        guard let songArtwork: MPMediaItemArtwork = song.artwork else { fatalError("error getting song artwork")}
        guard let songImage = songArtwork.image(at: CGSize(width: 40*0.25, height: 40*0.25)) else { fatalError("error getting image from artwork")}
        let sutImage: UIImage = sut.cellImage(sortType: .songs, indexPath: mockIndexPath)
        guard let data1: Data = UIImagePNGRepresentation(songImage) else { fatalError("error converting image to data") }
        let data2: Data = UIImagePNGRepresentation(sutImage)!;
        XCTAssertEqual(data1, data2)
    }
    
    func testCellLabelText_ShouldReturnProperLabel(){
        let mockIndexPath = IndexPath(row: 1, section: 0)
        guard let mediaSongs = MPMediaQuery.songs().items else { fatalError("error loading songs") }

            let song = mediaSongs[mockIndexPath.row]
            let songTitle = song.title
        
        XCTAssertEqual(sut.cellLabelText(sortType: MediaSortType.songs, indexPath: mockIndexPath), songTitle)
        
    }
    
    func testGetViewModelFromPopUp_ShouldGetSong(){
        let viewModel = sut.getViewModelFromPopUp()
    }
    
    
    
}

extension MainMusicViewModelTest {
//    class MockMusicPlayer: SwiftSimpleMusic.MusicPlayerProtocol {
//        
//        //        var currentSong: MPMediaItem? { get }
//        //        var nextSong: MPMediaItem? { get }
//        //        var previousSong: MPMediaItem? { get }
//        //        var collection: MediaCollection { get }
//        //        func play()
//        //        func beginSeekingForward()
//        //        func endSeeking()
//        //        func beginRewind()
//        //        func skipToNextItem()
//        //        func playPreviousItem()
//        //        func pause()
//        //        func stop()
//        //        func toggleShuffleMode()
//        //        func currentPlaybackState()-> MPMusicPlaybackState
//    }
}
