//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import AVFoundation
import UIKit

// MARK: - PlayerViewController

final class PlayerViewController: UIViewController {
    
    // MARK: Properties
    
    private let musicData = MusicData.shared
    
    public var postition: Int = 0
    public var tracks: [Track] = []
    
    var player: AVAudioPlayer?
    var holder: UIView! = UIView()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        setupUI()
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        view.addSubview(holder)
        holder.addSubview(songLabel)
        holder.addSubview(artistLabel)
        holder.addSubview(playPauseButton)
        holder.addSubview(previousTrackButton)
        holder.addSubview(nextTrackButton)
        
        holder.translatesAutoresizingMaskIntoConstraints = false
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        previousTrackButton.translatesAutoresizingMaskIntoConstraints = false
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            holder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            holder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            holder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            holder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            
            songLabel.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            songLabel.centerYAnchor.constraint(equalTo: holder.centerYAnchor),
            
            artistLabel.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            artistLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 10),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 130),
            
            nextTrackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            nextTrackButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 130),
            
            previousTrackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            previousTrackButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 130)
        ])
        
        let track = tracks[postition]
        songLabel.text = track.title
        artistLabel.text = track.artist
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
        previousTrackButton.setBackgroundImage(UIImage(systemName: "backward.end"), for: .normal)
        nextTrackButton.setBackgroundImage(UIImage(systemName: "forward.end"), for: .normal)
        
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        previousTrackButton.addTarget(self, action: #selector(didTapPreviousTrackButton), for: .touchUpInside)
        nextTrackButton.addTarget(self, action: #selector(didTapNextTrackButton), for: .touchUpInside)
    }
    
    // MARK: - Components
    
    private let songLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let playPauseButton = UIButton()
    let previousTrackButton = UIButton()
    let nextTrackButton = UIButton()
    
    
    // MARK: - Configuration
    
    private func configure() {
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
            player.volume = 0.1
            
        } catch {
            print("Error initializing AVAudioPlayer: \(error)")
        }
    }
    
    @objc func didTapPlayPauseButton() {
        print("Tapped")
        if let player = player {
            if player.isPlaying {
                player.pause()
                playPauseButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
            } else {
                player.play()
                playPauseButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
            }
        }
    }
    
    @objc func didTapPreviousTrackButton() {
        if postition > 0 {
            postition = postition - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
            setupUI()
        }
    }
    
    @objc func didTapNextTrackButton() {
        if postition < (tracks.count - 1) {
            postition = postition + 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
            setupUI()
        }
    }
}
