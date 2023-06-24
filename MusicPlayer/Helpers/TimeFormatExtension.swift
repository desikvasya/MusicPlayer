//
//  TimeFormatExtension.swift
//  MusicPlayer
//
//  Created by Denis on 24.06.2023.
//

import Foundation

extension TimeInterval {
    var formattedDuration: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
