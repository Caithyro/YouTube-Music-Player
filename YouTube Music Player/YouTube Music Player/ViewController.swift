//
//  ViewController.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 04.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var galleryContainer: UIView!
    @IBOutlet weak var topPlaylistNameLabel: UILabel!
    @IBOutlet weak var topPlaylistCollectionView: UICollectionView!
    @IBOutlet weak var bottomPlaylistNameLabel: UILabel!
    @IBOutlet weak var bottomPlaylistColletcionView: UICollectionView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerOpenCloseButton: UIButton!
    
    private let networkService = NetworkService.shared
    
    private var topPlaylistArray: [PlaylistItems] = []
    private var bottomPlaylistArray: [PlaylistItems] = []
    private var topPlaylistId = "PLN1mxegxWPd3d8jItTyrAxwm-iq-KrM-e"
    private var bottomPlaylistId = "OLAK5uy_m-wsk081gTHvqdTfPC7gKdKiTlqlxg9KM"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.topPlaylistCollectionView.register(UINib(nibName: "TopCollectionViewCell", bundle: nil),
                                                forCellWithReuseIdentifier: "TopCollectionViewCell")
        self.bottomPlaylistColletcionView.register(UINib(nibName: "BottomCollectionViewCell", bundle: nil),
                                                   forCellWithReuseIdentifier: "BottomCollectionViewCell")
        setupUI()
        loadPlaylists()
    }
    
    @IBAction func playerOpenCloseButtonPressed(_ sender: Any) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let playerViewController = main.instantiateViewController(withIdentifier:
                                                                        "PlayerViewController")
            as? PlayerViewController {
            playerViewController.topPlaylistArray = self.topPlaylistArray
            navigationController?.present(playerViewController, animated: true)
        }
    }
    
    //MARK: - Private
    
    private func setupUI() {
        
        topPlaylistCollectionView.layer.backgroundColor = CGColor(red: 0, green: 0,
                                                                  blue: 0, alpha: 0)
        bottomPlaylistColletcionView.layer.backgroundColor = CGColor(red: 0, green: 0,
                                                                     blue: 0, alpha: 0)
        self.playerView.layer.cornerRadius = 10
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func loadPlaylists() {
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.global(qos: .background).sync {
                self.networkService.fetchPlaylistForTopGallery(playlistId:
                                                                self.topPlaylistId) { items in
                    self.topPlaylistArray = items
                    self.topPlaylistCollectionView.reloadData()
                }
                self.networkService.fetchPlaylistNameForTopGallery(playlistID:
                                                                    self.topPlaylistId) { items in
                    self.topPlaylistNameLabel.text = items.first?.snippet?.title ?? "none"
                }
            }
            DispatchQueue.global(qos: .background).sync {
                self.networkService.fetchPlaylistForBottomGallery(playlistId:
                                                                    self.bottomPlaylistId) { items in
                    self.bottomPlaylistArray = items
                    self.bottomPlaylistColletcionView.reloadData()
                }
                self.networkService.fetchPlaylistNameForBottomGallery(playlistID:
                                                                        self.bottomPlaylistId) { items in
                    self.bottomPlaylistNameLabel.text = items.first?.snippet?.title ?? "none"
                }
            }
        }
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
            
            customCollectionViewCell.configureTopGalleryCell(index: indexPath.row,
                                                             videoId: topPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? "0",
                                                             dataToDisplay: topPlaylistArray[indexPath.row])
            
            return customCollectionViewCell
        } else {
            guard let customCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCollectionViewCell",
                                                                                    for: indexPath) as? BottomCollectionViewCell else { return UICollectionViewCell() }
            
            customCollectionViewCell.configureBottomGalleryCell(index: indexPath.row,
                                                                videoId: bottomPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? "0",
                                                                dataToDisplay: bottomPlaylistArray[indexPath.row])
            
            return customCollectionViewCell
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let playerViewController = main.instantiateViewController(withIdentifier:
                                                                        "PlayerViewController")
            as? PlayerViewController {
            playerViewController.indexPathRow = indexPath.row
            playerViewController.playlistIndex = indexPath.row
            if collectionView == topPlaylistCollectionView {
                playerViewController.topPlaylistArray = self.topPlaylistArray
                playerViewController.videoIdToLoad = self.topPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? ""
            } else {
                playerViewController.topOrBottom = 1
                playerViewController.bottomPlaylistArray = self.bottomPlaylistArray
                playerViewController.videoIdToLoad = self.bottomPlaylistArray[indexPath.row].snippet?.resourceId?.videoId ?? ""
            }
            navigationController?.present(playerViewController, animated: true)
        }
    }
}
