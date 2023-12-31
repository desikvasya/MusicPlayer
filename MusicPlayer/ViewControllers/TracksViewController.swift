//
//  TracksViewController.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import UIKit

// MARK: - Список всех треков

final class TracksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let musicData = MusicData.shared
    private var currentTrackIndex: Int = 0
    private let audioPlayer = AudioPlayerManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TracksViewCell.self, forCellReuseIdentifier: "TracksViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        // Задал констрейты для tableview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.allowsSelection = true
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicData.tracks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
        if position == currentTrackIndex {
            // если выбранный трек уже играет
            if audioPlayer.isPlaying {
                audioPlayer.pause()
            } else {
                audioPlayer.play()
            }
        } else {
            // если выбрать другой трек, который не воспроизводится
            currentTrackIndex = position // обновляет индекс трека
            audioPlayer.playTrack(at: position, tracks: musicData.tracks)
            
            let playerVC = PlayerViewController()
            playerVC.position = currentTrackIndex
            playerVC.tracks = musicData.tracks
            present(playerVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TracksViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TracksViewCell
        
        if cell == nil {
            cell = TracksViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let track = musicData.tracks[indexPath.row]
        
        // Отображение названия песни в формате (Название + Исполнитель)
        let combinedString = "\(track.title) - \(track.artist)"
        cell?.titleLabel.text = combinedString
        
        let formattedDuration = track.duration.formattedDuration
        cell?.durationLabel.text = formattedDuration
        
        cell?.fileName = track.fileName
        
        return cell!
    }
}
