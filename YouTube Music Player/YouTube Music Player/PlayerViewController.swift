//
//  PlayerViewController.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 08.10.2022.
//

import UIKit
import MediaPlayer
import youtube_ios_player_helper

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var oopenCloseButton: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var volumeView: MPVolumeView!
    
    var videoIdToLoad: String = ""
    var indexPathRow: Int = 0
    var topOrBottom: Int = 0
    var galleryOrCarousel: Int = 0
    var playlistId: String = ""
    var currentPage: Int = 0
    var carouselPlaylistArray: [PlaylistItems] = []
    var topPlaylistArray: [PlaylistItems] = []
    var bottomPlaylistArray: [PlaylistItems] = []
    
    private let serialQueue = DispatchQueue.global()
    
    private var musicPlaying: Bool = false
    private var videoDuration: Double = 0.0
    private var currentTimeOfPlayback: Float = 0.0
    private var playlistIndex: Int = 0
    private var networkService = NetworkService.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        playerView.delegate = self
        setupUI()
        loadData()
    }
    
    
    @IBAction func openCloseButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func timelineSliderValueChanged(_ sender: Any) {
        
        playerView.seek(toSeconds: self.timelineSlider.value,
                        allowSeekAhead: true)
        getCurrentTime()
        playButton.setImage(UIImage(named: "Pause"), for: .normal)
        musicPlaying = true
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        
        self.durationLabel.text = "0:00"
        switch galleryOrCarousel {
        case 0:
            changePlaylistIndex()
            playButtonPressed(self)
            if topOrBottom == 0 {
                serialQueue.sync {
                    self.playerView.load(withVideoId: self.topPlaylistArray[playlistIndex].snippet?.resourceId?.videoId ?? "0",
                                         playerVars: ["controls" : 0])
                }
                self.nameLabel.text = self.topPlaylistArray[playlistIndex].snippet?.title
            } else {
                serialQueue.sync {
                    self.playerView.load(withVideoId: self.bottomPlaylistArray[playlistIndex].snippet?.resourceId?.videoId ?? "0",
                                         playerVars: ["controls" : 0])
                }
                self.nameLabel.text = self.bottomPlaylistArray[playlistIndex].snippet?.title
            }
        case 1:
            changePlaylistIndex()
            self.nameLabel.text = carouselPlaylistArray[playlistIndex].snippet?.title
            DispatchQueue.global().sync {
                self.networkService.fetchViewsCountForCarousel(videoID: carouselPlaylistArray[playlistIndex].snippet?.resourceId?.videoId ?? "") { statisticsItems in
                    self.viewsCountLabel.text = "\(statisticsItems.first?.statistics?.viewCount ?? "") views"
                }
            }
            self.timelineSlider.value = 0
            self.currentTimeLabel.text = "0:00"
            self.playerView.previousVideo()
            getDurarion()
        default:
            print("error")
        }
        
        
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        if !musicPlaying {
            playButton.setImage(UIImage(named: "Pause"), for: .normal)
            playerView.playVideo()
            musicPlaying = true
        } else {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            playerView.pauseVideo()
            musicPlaying = false
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        self.durationLabel.text = "0:00"
        switch galleryOrCarousel {
        case 0:
            if playlistIndex == (topPlaylistArray.count - 1) {
                playlistIndex = (topPlaylistArray.count - 1)
            } else {
                playlistIndex = indexPathRow + 1
            }
            playButtonPressed(self)
            if topOrBottom == 0 {
                serialQueue.sync {
                    self.playerView.load(withVideoId: self.topPlaylistArray[playlistIndex].snippet?.resourceId?.videoId ?? "0",
                                         playerVars: ["controls" : 0])
                }
                self.nameLabel.text = self.topPlaylistArray[playlistIndex].snippet?.title
            } else {
                serialQueue.sync {
                    self.playerView.load(withVideoId: self.bottomPlaylistArray[playlistIndex].snippet?.resourceId?.videoId ?? "0",
                                         playerVars: ["controls" : 0])
                }
                self.nameLabel.text = self.bottomPlaylistArray[playlistIndex].snippet?.title
            }
        case 1:
            if playlistIndex == (carouselPlaylistArray.count - 1) {
                playlistIndex = (carouselPlaylistArray.count - 1)
            } else {
                playlistIndex = playlistIndex + 1
            }
            self.nameLabel.text = carouselPlaylistArray[playlistIndex].snippet?.title
            DispatchQueue.global().sync {
                self.networkService.fetchViewsCountForCarousel(videoID: carouselPlaylistArray[self.playlistIndex].snippet?.resourceId?.videoId ?? "") { statisticsItems in
                    self.viewsCountLabel.text = "\(statisticsItems.first?.statistics?.viewCount ?? "") views"
                }
            }
            self.timelineSlider.value = 0
            self.currentTimeLabel.text = "0:00"
            self.playerView.nextVideo()
            self.playButtonPressed(self)
            getDurarion()
        default:
            print("error")
        }
        
    }
    
    //MARK: - Private
    
    private func changePlaylistIndex() {
        
        if playlistIndex == (topPlaylistArray.count - 1) {
            playlistIndex = (topPlaylistArray.count - 1)
        } else {
            playlistIndex = indexPathRow + 1
        }
    }
    
    private func setupUI() {
        
        setGradientBackground(view: self.view)
        switch galleryOrCarousel {
        case 0:
            loadViewsCountForGallery()
        default: break
            
        }
    }
    
    private func setGradientBackground(view: UIView) {
        
        let colorTop =  UIColor(red: 220.0/255.0, green: 81.0/255.0,
                                blue: 137.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 88.0/255.0, green: 35.0/255.0,
                                  blue: 194.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = 25
        
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    private func loadViewsCountForGallery() {
        
        if topOrBottom == 0 {
            self.nameLabel.text = topPlaylistArray[indexPathRow].snippet?.title
            serialQueue.sync {
                networkService.fetchViewsCountForTopGallery(videoID: videoIdToLoad) { statisticItems in
                    self.viewsCountLabel.text = "\(statisticItems.first?.statistics?.viewCount ?? "Unknown") views"
                }
            }
        } else {
            self.nameLabel.text = bottomPlaylistArray[indexPathRow].snippet?.title
            serialQueue.sync {
                networkService.fetchViewsCountForBottomGallery(videoID: videoIdToLoad) { statisticItems in
                    self.viewsCountLabel.text = "\(statisticItems.first?.statistics?.viewCount ?? "Unknown") views"
                }
            }
        }
    }
    
    private func loadData() {
        
        switch galleryOrCarousel {
        case 0:
            if topOrBottom == 0 {
                serialQueue.sync {
                    self.playerView.load(withVideoId: topPlaylistArray[indexPathRow].snippet?.resourceId?.videoId ?? "",
                                         playerVars: ["controls" : 0])
                }
            } else {
                serialQueue.sync {
                    self.playerView.load(withVideoId: bottomPlaylistArray[indexPathRow].snippet?.resourceId?.videoId ?? "",
                                         playerVars: ["controls" : 0])
                }
            }
        case 1:
            serialQueue.sync {
                networkService.fetchPlaylistForCarousel(playlistId: self.playlistId) { items in
                    self.carouselPlaylistArray = items
                    self.nameLabel.text = items[0].snippet?.title
                    self.networkService.fetchViewsCountForCarousel(videoID: items.first?.snippet?.resourceId?.videoId ?? "") { statisticsItems in
                        self.viewsCountLabel.text = "\(statisticsItems.first?.statistics?.viewCount ?? "") views"
                    }
                }
                self.playerView.load(withPlaylistId: playlistId, playerVars: ["controls" : 0])
            }
        default:
            print("Unexpected error")
        }
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func getCurrentTime() {
        
        self.playerView.currentTime { currentTime, error in
            if error == nil {
                self.currentTimeOfPlayback = currentTime
                let hours: Int = self.secondsToHoursMinutesSeconds(Int(currentTime)).0
                let minutes: Int = self.secondsToHoursMinutesSeconds(Int(currentTime)).1
                let seconds: Int = self.secondsToHoursMinutesSeconds(Int(currentTime)).2
                if hours == 0 {
                    self.currentTimeLabel.text = String(describing: minutes) + ":" + String(format:
                                                                                                "%02d", Int(seconds))
                } else {
                    self.currentTimeLabel.text = String(describing: hours) + ":" + String(describing:
                                                                                            minutes) + ":" + String(format: "%02d", Int(seconds))
                }
            } else {
                print(error!)
            }
        }
    }
    
    private func getDurarion() {
        
        self.playerView.duration { duration, error in
            if error == nil {
                self.videoDuration = duration
                self.timelineSlider.maximumValue = Float(duration)
                let hours: Int = self.secondsToHoursMinutesSeconds(Int(duration)).0
                let minutes: Int = self.secondsToHoursMinutesSeconds(Int(duration)).1
                let seconds: Int = self.secondsToHoursMinutesSeconds(Int(duration)).2
                if hours == 0 {
                    self.durationLabel.text = String(describing: minutes) + ":" + String(format:
                                                                                            "%02d", Int(seconds))
                } else {
                    self.durationLabel.text = String(describing: hours) + ":" + String(describing:
                                                                                        minutes) + ":" + String(format: "%02d", Int(seconds))
                }
            } else {
                print(error!)
            }
        }
    }
}

extension PlayerViewController: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        getCurrentTime()
        getDurarion()
        self.timelineSlider.maximumValue = Float(self.videoDuration)
        self.timelineSlider.value = currentTimeOfPlayback
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        
        self.timelineSlider.value = playTime
        
        let hours: Int = self.secondsToHoursMinutesSeconds(Int(playTime)).0
        let minutes: Int = self.secondsToHoursMinutesSeconds(Int(playTime)).1
        let seconds: Int = self.secondsToHoursMinutesSeconds(Int(playTime)).2
        
        if hours == 0 {
            self.currentTimeLabel.text = String(describing: minutes) + ":" + String(format:
                                                                                        "%02d", Int(seconds))
        } else {
            self.currentTimeLabel.text = String(describing: hours) + ":" + String(describing:
                                                                                    minutes) + ":" + String(format: "%02d", Int(seconds))
        }
    }
}
