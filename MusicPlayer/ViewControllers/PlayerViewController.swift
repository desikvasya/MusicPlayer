//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import AVFoundation
import UIKit

// MARK: - Плеер, где воспроизводится музыка

final class PlayerViewController: UIViewController {
    
    private let musicData = MusicData.shared
    
    public var postition: Int = 0
    public var tracks: [Track] = []
    
    var player: AVAudioPlayer?
    var holder: UIView! = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    func configure() {
        let track = tracks[postition]
        
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            print("Failed to retrieve URL for the audio file.")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else {
                print("Failed to create AVAudioPlayer.")
                return
            }
            
            player.play()
            
        } catch {
            print("Error initializing AVAudioPlayer: \(error)")
        }
    }
    
}
