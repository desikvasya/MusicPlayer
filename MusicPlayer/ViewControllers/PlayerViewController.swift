//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import AVFoundation
import UIKit

protocol AudioPlayerManagerDelegate: AnyObject {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
}

// MARK: - PlayerViewController

final class PlayerViewController: UIViewController, AudioPlayerManagerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didTapNextTrackButton()
    }
    
    internal let audioPlayerManager = AudioPlayerManager.shared
    
    public var position: Int = 0
    public var tracks: [Track] = []
    private var progressView: UIProgressView!
    private var currentTrack: Track?
    
    
    var holder: UIView! = UIView()
    var progressUpdateTimer: Timer?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        setupUI()
        
        audioPlayerManager.delegate = self
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
        
        holder.addSubview(closeButton)
        
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
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            songDurationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: holder.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: 20)
        ])
        
        let track = tracks[position]
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
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    let playPauseButton = UIButton()
    let previousTrackButton = UIButton()
    let nextTrackButton = UIButton()
    
    // MARK: - Configuration
    
    private func configure() {
        let track = tracks[position]
        currentTrack = track
        
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            print("Failed to retrieve URL for the audio file.")
            return
        }
        
        let asset = AVAsset(url: url)
        let duration = asset.duration.seconds
        let formattedDuration = TimeInterval.stringFromTimeInterval(duration)
        songDurationLabel.text = formattedDuration
        
        audioPlayerManager.loadAudio(with: url)
        audioPlayerManager.play()
        audioPlayerManager.volume = 0.1
    }
    
    
    func updateProgressView() {
        
        let duration = audioPlayerManager.duration
        let currentTime = audioPlayerManager.currentTime
        let progress = Float(currentTime / duration)
        progressView.setProgress(progress, animated: true)
        
        currentTimeLabel.text = TimeInterval.stringFromTimeInterval(currentTime)
    }
    
    private func configureProgressView() {
        guard let audioPlayer = audioPlayerManager.audioPlayer else {
            return
        }
    }
    
    func startProgressUpdateTimer() {
        updateProgressView()
        
        progressUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgressView()
        }
    }
    
    @objc func didTapPlayPauseButton() {
        if audioPlayerManager.isPlaying {
            audioPlayerManager.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        } else {
            audioPlayerManager.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
        }
        configureProgressView()
    }
    
    @objc func didTapPreviousTrackButton() {
        audioPlayerManager.stop()
        
        if position == 0 {
            position = tracks.count - 1
        } else {
            position -= 1
        } // переключается на предыдущий трек или на самый последний, если нажали на первом треке
        
        configure()
        setupUI()
        configureProgressView()
        audioPlayerManager.play()
    }
    
    @objc func didTapNextTrackButton() {
        audioPlayerManager.stop()
        position = (position + 1) % tracks.count // переключается на следующий трек или на самый первый, если нажали на последнем треке
        configure()
        setupUI()
        configureProgressView()
        audioPlayerManager.play()
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
