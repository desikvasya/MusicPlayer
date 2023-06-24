//
//  TracksViewController.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import UIKit

final class TracksViewController: UIViewController, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let musicData = MusicData.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TracksViewCell.self, forCellReuseIdentifier: "TracksViewCell")
        tableView.dataSource = self
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
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicData.tracks.count
    }
}

extension TracksViewController {
    
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
