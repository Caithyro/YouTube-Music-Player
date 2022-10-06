//
//  ViewController.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 04.10.2022.
//

import UIKit
import youtube_ios_player_helper

class ViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var galleryContainer: UIView!
    @IBOutlet weak var topPlaylistNameLabel: UILabel!
    @IBOutlet weak var topPlaylistCollectionView: UICollectionView!
    @IBOutlet weak var bottomPlaylistNameLabel: UILabel!
    @IBOutlet weak var bottomPlaylistColletcionView: UICollectionView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerOpenCloseButton: UIButton!
    @IBOutlet weak var playerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var youTubePlayerView: YTPlayerView!
    
    private var playerIsActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topPlaylistCollectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: nil),
                                                forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        self.bottomPlaylistColletcionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: nil),
                                                   forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
    }
    
    @IBAction func playerOpenCloseButtonPressed(_ sender: Any) {
        
        if !playerIsActive {
            playerViewBottomConstraint.constant = 0
            playerOpenCloseButton.setImage(UIImage(named: "Close"), for: .normal)
            playerIsActive = true
        } else {
            playerViewBottomConstraint.constant = -685
            playerOpenCloseButton.setImage(UIImage(named: "Open"), for: .normal)
            playerIsActive = false
        }
    }
    
    //MARK: - Private
    
    private func setGradientBackground(view: UIView) {
        
        let colorTop =  UIColor(red: 220.0/255.0, green: 81.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 88.0/255.0, green: 35.0/255.0, blue: 194.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = 25
        
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    private func setupUi() {
        
        topPlaylistCollectionView.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        bottomPlaylistColletcionView.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.playerView.layer.cornerRadius = 25
        setGradientBackground(view: playerView)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let customCollectionViewCell = topPlaylistCollectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell",
                                                                                           for: indexPath) as? PlaylistCollectionViewCell else { return UICollectionViewCell() }
        return customCollectionViewCell
    }
}




