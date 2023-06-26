//
//  AudioPlayerManager.swift
//  MusicPlayer
//
//  Created by Denis on 26.06.2023.
//

import AVFoundation
import UIKit

// MARK: - AudioPlayerManager

final class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayerManager()
    private var currentTrack: Track?
    private var currentTrackIndex: Int = 0
    private var tracks: [Track] = []
    
    
    
    weak var delegate: AudioPlayerManagerDelegate?
    
    public var position: Int = 0
    
    
    var audioPlayer: AVAudioPlayer?
    
    func loadAudio(with url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to load audio file with error: \(error.localizedDescription)")
        }
    }
    
    
    func playTrack(at index: Int, tracks: [Track]) {
        guard index >= 0, index < tracks.count else {
            print("Invalid track index")
            return
        }
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var currentTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    
    var duration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    var volume: Float {
        get {
            return audioPlayer?.volume ?? 0
        }
        set {
            audioPlayer?.volume = newValue
        }
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    // переключение трека на следующий, когда текущий заканчивается
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            let nextIndex = currentTrackIndex + 1
            playTrack(at: nextIndex, tracks: tracks)
        }
    }
    
}

