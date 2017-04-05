//
//  SearchSection.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 3/16/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import Foundation

enum SearchSection {
    case songs, albums, artists
    
    static func typeForSection(_ section: Int) -> SearchSection {
        switch section {
        case 0:
            return SearchSection.songs
        case 1:
            return SearchSection.albums
        case 2:
            return SearchSection.artists
        default:
            fatalError("invalid section")
        }
    }
    
    func sortType() -> MediaSortType {
        switch self {
        case .songs:
            return MediaSortType.songs
        case .albums:
            return MediaSortType.albums
        case .artists:
            return MediaSortType.artists
        }
    }
}

extension SearchSection: CustomStringConvertible {
    var description: String {
        switch self {
        case .songs:
            return "Songs"
        case .albums:
            return "Albums"
        case .artists:
            return "Artists"
        }
    }
}
