//
//  BottomCollectionViewCell.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 07.10.2022.
//

import UIKit
import SDWebImage

class BottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    private let networkService = NetworkService.shared
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 155, height: 87.33),
                                                         scaleMode: .fill)
    
    func configureBottomGalleryCell(index: Int, videoId: String, dataToDisplay: PlaylistItems) {
        
        networkService.fetchViewsCountForBottomGallery(videoID: videoId) { statisticItems in
            self.viewCountLabel.text = "\(statisticItems.first?.statistics?.viewCount ?? "89") views"
        }
        self.songNameLabel.text = dataToDisplay.snippet?.title
        self.thumbnailImageView.layer.cornerRadius = 10
        self.thumbnailImageView.sd_setImage(with: URL(string: dataToDisplay.snippet?.thumbnails?.maxres?.url ?? "none"),
                                            placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
    }
    
}
