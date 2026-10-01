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
    var library: FakeSongLibrary!
    
    override func setUp() {
        super.setUp()
        library = FakeSongLibrary(songsPerSection: 2)
        sut = MainMusicViewModel(player: MockMusicPlayer(), mediaDictionary: [.songs: library.collection])
    }
    
    override func tearDown() {
        sut = nil
        library = nil
        super.tearDown()
    }
    
    func testTitleForSection_ShouldReturnLetter(){
        XCTAssertEqual(sut.titleForSection(sortType: .songs, section: 0), "A")
        XCTAssertEqual(sut.titleForSection(sortType: .songs, section: 25), "Z")
    }
    
    func testNumberOfRowsForSection_ShouldReturnCorrectInt(){
        XCTAssertEqual(sut.numberOfRowsForSection(sortType: .songs, section: 1), 2)
    }
    
    func testSectionIndexTitles_ShouldReturnAllIndexTitles(){
        let sutTitles = sut.sectionIndexTitles(sortType: .songs)
        XCTAssertEqual(sutTitles, FakeSongLibrary.letters)
        XCTAssertEqual(sutTitles[25], "Z")
    }
    
    func testCellImage_ShouldReturnProperImage(){
        // Row 1 of section 1 ("B") is the 4th song overall.
        let indexPath = IndexPath(row: 1, section: 1)
        let expected = library.artworkImage(forSongAt: 3)
        let sutImage = sut.cellImage(sortType: .songs, indexPath: indexPath)
        XCTAssertEqual(sutImage.pngData(), expected.pngData())
    }
    
    func testCellImage_WithoutArtwork_ShouldReturnDefaultImage(){
        let library = FakeSongLibrary(songsPerSection: 1, includeArtwork: false)
        let sut = MainMusicViewModel(player: MockMusicPlayer(), mediaDictionary: [.songs: library.collection])
        let sutImage = sut.cellImage(sortType: .songs, indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(sutImage.pngData(), UIImage(named: "noteSml.png")?.pngData())
    }
    
    func testCellLabelText_ShouldReturnProperLabel(){
        let label = sut.cellLabelText(sortType: .songs, indexPath: IndexPath(row: 1, section: 1))
        XCTAssertEqual(label?.title, "B Song 2")
        XCTAssertEqual(label?.detail, "B Artist--B Album")
    }
}

// MARK: - Fixtures

/// MPMediaItem's properties are read-only, so tests subclass it to supply values.
final class FakeMediaItem: MPMediaItem {
    private let fakeTitle: String
    private let fakeArtist: String
    private let fakeAlbumTitle: String
    private let fakeArtwork: MPMediaItemArtwork?
    
    init(title: String, artist: String, albumTitle: String, artwork: MPMediaItemArtwork?) {
        fakeTitle = title
        fakeArtist = artist
        fakeAlbumTitle = albumTitle
        fakeArtwork = artwork
        super.init()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override var title: String? { fakeTitle }
    override var artist: String? { fakeArtist }
    override var albumTitle: String? { fakeAlbumTitle }
    override var artwork: MPMediaItemArtwork? { fakeArtwork }
}

struct FakeQuerySection: MediaSection {
    let title: String
    let range: NSRange
}

/// A songs library with one section per letter A–Z, laid out like `MPMediaQuery.songs()`:
/// a flat item list with each section covering a contiguous range of it.
struct FakeSongLibrary {
    static let letters = (65...90).map { String(UnicodeScalar($0)!) }
    
    let collection: SubGroupCollection
    private let artworkImages: [UIImage]
    
    init(songsPerSection: Int, includeArtwork: Bool = true) {
        var items: [MPMediaItem] = []
        var sections: [MediaSection] = []
        var images: [UIImage] = []
        for letter in Self.letters {
            sections.append(FakeQuerySection(title: letter, range: NSRange(location: items.count, length: songsPerSection)))
            for number in 1...songsPerSection {
                let image = Self.solidImage(hue: CGFloat(items.count) / CGFloat(Self.letters.count * songsPerSection))
                images.append(image)
                let artwork = includeArtwork ? MPMediaItemArtwork(boundsSize: image.size) { _ in image } : nil
                items.append(FakeMediaItem(title: "\(letter) Song \(number)", artist: "\(letter) Artist", albumTitle: "\(letter) Album", artwork: artwork))
            }
        }
        // The view model indexes `collections` alongside `items`, so keep them the same length.
        let collections = items.map { MPMediaItemCollection(items: [$0]) }
        collection = SubGroupCollection(items: items, collections: collections, sections: sections, sortType: .songs)
        artworkImages = images
    }
    
    func artworkImage(forSongAt index: Int) -> UIImage {
        artworkImages[index]
    }
    
    private static func solidImage(hue: CGFloat) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4)).image { context in
            UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
        }
    }
}

/// No-op player so view model tests don't need real media library access.
/// Shared with other tests in this target.
final class MockMusicPlayer: MusicPlayerProtocol {
    var currentSong: MPMediaItem?
    var nextSong: MPMediaItem?
    var previousSong: MPMediaItem?
    var repeatMode: MPMusicRepeatMode = .none
    var shuffleMode: MPMusicShuffleMode = .off
    var collection = MediaCollection(items: [])
    var playbackState: MPMusicPlaybackState = .stopped

    func play() {}
    func playItem(_ item: MPMediaItem) {}
    func beginSeekingForward() {}
    func endSeeking() {}
    func beginRewind() {}
    func skipToNextItem() {}
    func playPreviousItem() {}
    func pause() {}
    func stop() {}
    func toggleShuffleMode(shuffleButton: UIBarButtonItem) {}
    func toggleLoopMode(loopButton: UIBarButtonItem) {}
    func currentPlaybackState() -> MPMusicPlaybackState { playbackState }
    func setPlayerQueue(with: MPMediaQuery) {}
    func setPlayerQueue(with: MPMediaItemCollection) {}
}
