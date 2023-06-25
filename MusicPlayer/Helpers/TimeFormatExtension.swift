//
//  TimeFormatExtension.swift
//  MusicPlayer
//
//  Created by Denis on 24.06.2023.
//


import Foundation

// MARK: - Расширение для отображения длительности песни в формате 00:00 (минуты и секунды)

extension TimeInterval {
    var formattedDuration: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    static func stringFromTimeInterval(_ interval: TimeInterval) -> String {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            formatter.allowedUnits = [.minute, .second]
            
            return formatter.string(from: interval) ?? ""
        }
}
