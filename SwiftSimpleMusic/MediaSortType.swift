//
//  MediaSortType.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/5/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import Foundation

enum MediaSortType: CustomStringConvertible {
    case songs, albums, artists, genres, playlists, podcasts, compilations, audiobooks
    
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
