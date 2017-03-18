//
//  MediaSortType.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/5/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import Foundation

enum MediaSortType {
    case songs, albums, artists, genres, playlists, podcasts, compilations, audiobooks
    
    static func getNextTypeFromText(_ sortTypeText: String) -> MediaSortType {
        switch sortTypeText {
        case "Songs":
            return .albums
        case "Albums":
            return .artists
        case "Artists":
            return .genres
        case "Genres":
            return .playlists
        case "Playlists":
            return .podcasts
        case "Podcasts":
            return .audiobooks
        case "Audiobooks":
            return .compilations
        case "Compilations":
            return .songs
        default:
            return .songs
        }
    }
}
extension MediaSortType: CustomStringConvertible {
    var description: String {
        switch self {
        // Use Internationalization, as appropriate.
        case .songs: return "Songs"
        case .albums: return "Albums"
        case .artists: return "Artists"
        case .genres: return "Genres"
        case .playlists: return "Playlists"
        case .podcasts: return "Podcasts"
        case .compilations: return "Compilations"
        case .audiobooks: return "Audio Books"
            
        }
    }
}
