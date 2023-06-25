//
//  TracksViewCell.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import UIKit

// MARK: - Ячейки для песен

final class TracksViewCell: UITableViewCell {
    
    var titleLabel: UILabel! // Информация о треке (Название + Исполнитель)
    
    var durationLabel: UILabel!
    var fileName: String?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        durationLabel = UILabel()
        
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
