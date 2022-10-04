//
//  ViewController.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 04.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var galleryContainer: UIView!
    @IBOutlet weak var topPlaylistNameLabel: UILabel!
    @IBOutlet weak var topPlaylistCollectionView: UICollectionView!
    @IBOutlet weak var bottomPlaylistNameLabel: UILabel!
    @IBOutlet weak var bottomPlaylistColletcionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topPlaylistCollectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: nil),
                                                forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        self.bottomPlaylistColletcionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: nil),
                                                   forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        topPlaylistCollectionView.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        bottomPlaylistColletcionView.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
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




