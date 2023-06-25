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
    private var progressView: UIProgressView!
    
    
    var player: AVAudioPlayer?
    var holder: UIView! = UIView()
    var progressUpdateTimer: Timer?
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(holder)
        holder.addSubview(songLabel)
        holder.addSubview(artistLabel)
        
        holder.addSubview(playPauseButton)
        holder.addSubview(previousTrackButton)
        holder.addSubview(nextTrackButton)
        
        holder.addSubview(songDurationLabel)
        holder.addSubview(currentTimeLabel)
        
        
        // ProgressView
        progressView = UIProgressView(progressViewStyle: .default)
        
        let veryLightGrey = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        progressView.trackTintColor = veryLightGrey
        progressView.progressTintColor = .systemBlue
        
        holder.addSubview(progressView)
        
        holder.translatesAutoresizingMaskIntoConstraints = false
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        previousTrackButton.translatesAutoresizingMaskIntoConstraints = false
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        songDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            holder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            holder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            holder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            holder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            songLabel.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            songLabel.centerYAnchor.constraint(equalTo: holder.centerYAnchor, constant: 50),
            
            artistLabel.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            artistLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 10),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 120),
            
            nextTrackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            nextTrackButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 120),
            
            previousTrackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            previousTrackButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 120),
            
            progressView.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 70),
            progressView.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -20),
            
            currentTimeLabel.bottomAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 45),
            currentTimeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            songDurationLabel.bottomAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 45),
            songDurationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
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
        
        configureProgressView()
        startProgressUpdateTimer()
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
    
    private let songDurationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    private func configureProgressView() {
        guard let player = player else {
            return
        }
        
        progressView.progress = 0
        
        let duration = player.duration
        let currentTime = player.currentTime
        let progress = Float(currentTime / duration)
        progressView.setProgress(progress, animated: true)
        
        songDurationLabel.text = TimeInterval.stringFromTimeInterval(duration)
        currentTimeLabel.text = TimeInterval.stringFromTimeInterval(currentTime)
        
        
    }
    
    private func startProgressUpdateTimer() {
        updateProgressView() 
        
        progressUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgressView()
        }
    }

    
    private func updateProgressView() {
        guard let player = player else {
            return
        }
        
        let duration = player.duration
        let currentTime = player.currentTime
        let progress = Float(currentTime / duration)
        progressView.setProgress(progress, animated: true)
        
        currentTimeLabel.text = TimeInterval.stringFromTimeInterval(currentTime)
    }
    
    @objc func didTapPlayPauseButton() {
        if let player = player {
            if player.isPlaying {
                player.pause()
                playPauseButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
            } else {
                player.play()
                playPauseButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
            }
            configureProgressView()
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
            configureProgressView()
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
            configureProgressView()
        }
    }
}
