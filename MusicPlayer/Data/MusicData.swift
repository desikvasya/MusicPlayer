//
//  MusicData.swift
//  MusicPlayer
//
//  Created by Denis on 24.06.2023.
//

import Foundation

// MARK: - Список песен, куда можно добавлять новые треки и менять информацию о существующих

class MusicData {
    static let shared = MusicData()
    
    let tracks: [Track] = [
        Track(title: "No Roots", artist: "Alice Merton", duration: 237.11, fileName: "Alice Merton - No Roots"),
        Track(title: "Carry On Wayward Son", artist: "Kansas", duration: 205.27, fileName: "Kansas - Carry On Wayward Son"),
        Track(title: "Warriors", artist: "Imagine Dragons", duration: 170.92, fileName: "Imagine Dragons - Warriors"),
        Track(title: "Counting Stars", artist: "One Republic", duration: 256.03, fileName: "One Republic - Counting Stars"),
        Track(title: "Another World", artist: "One Direction", duration: 203.39, fileName: "One Direction - Another World")
    ]
}
