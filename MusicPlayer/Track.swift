//
//  Track.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import Foundation

struct Track {
    let title: String
    let artist: String
    let duration: TimeInterval
    let fileName: String
    
    var formattedDuration: String {
        return duration.formattedDuration
    }
}

