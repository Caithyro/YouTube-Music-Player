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
    @IBOutlet weak var videoTimelineSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var videoViewsCountLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previousSongButton: UIButton!
    @IBOutlet weak var nextSongButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    private let networkService = NetworkService.shared
    private let concurrentQueue = DispatchQueue.global(qos: .userInitiated)
    
    private var playerIsActive: Bool = false
    private var musicPlaying: Bool = false
    private var topPlaylistArray: [PlaylistItems] = []
    private var bottomPlaylistArray: [PlaylistItems] = []
    private var topPlaylistId = "PLN1mxegxWPd3d8jItTyrAxwm-iq-KrM-e"
    private var bottomPlaylistId = "OLAK5uy_m-wsk081gTHvqdTfPC7gKdKiTlqlxg9KM"
    private var playlistArray: [String] = []
    private var indexPathRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topPlaylistCollectionView.register(UINib(nibName: "TopCollectionViewCell", bundle: nil),
                                                forCellWithReuseIdentifier: "TopCollectionViewCell")
        self.bottomPlaylistColletcionView.register(UINib(nibName: "BottomCollectionViewCell", bundle: nil),
                                                   forCellWithReuseIdentifier: "BottomCollectionViewCell")
        setupUI()
        loadPlaylists()
    }
    
    @IBAction func videoTimelineSliderValueChanged(_ sender: Any) {
        print(videoTimelineSlider.value)
    }
    
    @IBAction func volumeSliderValueChanged(_ sender: Any) {
        print(volumeSlider.value)
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
    
    @IBAction func previousSongButtonPressed(_ sender: Any) {
        if indexPathRow == 0 {
            indexPathRow = 0
        } else {
            indexPathRow = indexPathRow - 1
        }
        concurrentQueue.sync {
            self.youTubePlayerView.load(withVideoId: self.topPlaylistArray[self.indexPathRow].snippet?.resourceId?.videoId ?? "0")
        }
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if !musicPlaying {
            playButton.setImage(UIImage(named: "Pause"), for: .normal)
            youTubePlayerView.playVideo()
            musicPlaying = true
        } else {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            youTubePlayerView.pauseVideo()
            musicPlaying = false
        }
    }
    
    @IBAction func nextSongButtonPressed(_ sender: Any) {
        if indexPathRow == (topPlaylistArray.count - 1) {
            indexPathRow = (topPlaylistArray.count - 1)
        } else {
            indexPathRow = indexPathRow + 1
        }
        concurrentQueue.sync {
            self.youTubePlayerView.load(withVideoId: self.topPlaylistArray[indexPathRow].snippet?.resourceId?.videoId ?? "0")
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
    
    private func setupUI() {
        
        topPlaylistCollectionView.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        bottomPlaylistColletcionView.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.playerView.layer.cornerRadius = 25
        setGradientBackground(view: playerView)
    }
    
    private func loadPlaylists() {
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.global(qos: .background).sync {
                self.networkService.fetchDataForTopGallery(playlistId: self.topPlaylistId) { items in
                    self.topPlaylistArray = items
                    self.topPlaylistCollectionView.reloadData()
                }
                self.networkService.fetchPlaylistNameForTopGallery(playlistID: self.topPlaylistId) { items in
                    self.topPlaylistNameLabel.text = items.first?.snippet?.title ?? "none"
                }
            }
            DispatchQueue.global(qos: .background).sync {
                self.networkService.fetchDataForBottomGallery(playlistId: self.bottomPlaylistId) { items in
                    self.bottomPlaylistArray = items
                    self.bottomPlaylistColletcionView.reloadData()
                }
                self.networkService.fetchPlaylistNameForBottomGallery(playlistID: self.bottomPlaylistId) { items in
                    self.bottomPlaylistNameLabel.text = items.first?.snippet?.title ?? "none"
                }
            }
        }
    }
    
    private func createPlaylist() {
        
        var indexForAppend = 0
        for _ in topPlaylistArray {
            self.playlistArray.append(self.topPlaylistArray[indexForAppend].snippet?.resourceId?.videoId ?? "0")
            indexForAppend += 1
        }
        indexForAppend = 0
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topPlaylistCollectionView {
            return topPlaylistArray.count
        } else {
            return bottomPlaylistArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topPlaylistCollectionView {
            
            guard let customCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell",
                                                                                               for: indexPath) as? TopCollectionViewCell else { return UICollectionViewCell() }
            
            customCollectionViewCell.configureTopGalleryCell(index: indexPath.row, videoId: topPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? "0", dataToDisplay: topPlaylistArray[indexPath.row])
            
            return customCollectionViewCell
        } else {
            
            guard let customCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCollectionViewCell",
                                                                                               for: indexPath) as? BottomCollectionViewCell else { return UICollectionViewCell() }
            
            customCollectionViewCell.configureBottomGalleryCell(index: indexPath.row, videoId: bottomPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? "0", dataToDisplay: bottomPlaylistArray[indexPath.row])
            
            return customCollectionViewCell
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexPathRow = indexPath.row
        playerOpenCloseButtonPressed(ViewController())
        if collectionView == topPlaylistCollectionView {
            concurrentQueue.sync {
                self.youTubePlayerView.load(withVideoId: self.topPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? "0", playerVars: ["controls" : 0])
            }
        } else {
            concurrentQueue.sync {
                self.youTubePlayerView.load(withVideoId: self.bottomPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? "0", playerVars: ["controls" : 0])
            }
        }
        
    }
}
