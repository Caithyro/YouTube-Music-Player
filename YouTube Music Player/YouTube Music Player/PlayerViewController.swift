//
//  PlayerViewController.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 08.10.2022.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController {

    @IBOutlet weak var oopenCloseButton: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeleftLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var videoIdToLoad: String = ""
    var indexPathRow: Int = 0
    var topOrBottom: Int = 0
    var galleryOrCarousel: Int = 0
    var playlistId: String = ""
    var carouselPlaylistArray: [PlaylistItems] = []
    var topPlaylistArray: [PlaylistItems] = []
    var bottomPlaylistArray: [PlaylistItems] = []
    
    private let serialQueue = DispatchQueue.global()
    
    private var musicPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if galleryOrCarousel == 0{
            if topOrBottom == 0{
                self.playerView.load(withVideoId: topPlaylistArray[indexPathRow].snippet?.resourceId?.videoId ?? "", playerVars: ["controls" : 0])
            } else {
                self.playerView.load(withVideoId: bottomPlaylistArray[indexPathRow].snippet?.resourceId?.videoId ?? "", playerVars: ["controls" : 0])
            }
        } else {
            self.playerView.load(withPlaylistId: playlistId, playerVars: ["controls" : 0])
        }
        
    }
    
    
    @IBAction func openCloseButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func timelineSliderValueChanged(_ sender: Any) {
        
        print("seek to\(timelineSlider.value)")
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        
        switch galleryOrCarousel {
        case 0:
            if indexPathRow == 0 {
                indexPathRow = 0
            } else {
                indexPathRow = indexPathRow - 1
            }
            playButtonPressed(self)
            serialQueue.sync {
                self.playerView.load(withVideoId: self.topPlaylistArray[self.indexPathRow].snippet?.resourceId?.videoId ?? "0")
            }
        case 1:
            self.playerView.previousVideo()
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
        
        switch galleryOrCarousel {
        case 0:
            if indexPathRow == (topPlaylistArray.count - 1) {
                indexPathRow = (topPlaylistArray.count - 1)
            } else {
                indexPathRow = indexPathRow + 1
            }
            playButtonPressed(self)
            serialQueue.sync {
                self.playerView.load(withVideoId: self.topPlaylistArray[indexPathRow].snippet?.resourceId?.videoId ?? "0")
            }
        case 1:
            self.playerView.nextVideo()
        default:
            print("error")
        }
        
    }
    
    @IBAction func volumeSliderValueChanged(_ sender: Any) {
        
        print("set volume to\(volumeSlider.value)")
    }
    
    private func setupUI() {
        
        setGradientBackground(view: self.view)
    }
    
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
}
