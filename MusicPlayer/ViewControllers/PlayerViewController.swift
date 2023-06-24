//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Denis on 23.06.2023.
//

import Foundation
import UIKit

final class PlayerViewController: UIViewController {
    
    private let musicData = MusicData.shared

    public var postition: Int = 0
    public var tracks: [Track] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
