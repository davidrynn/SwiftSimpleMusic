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
