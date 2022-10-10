//
//  CarouselItem.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 04.10.2022.
//

import UIKit
import SDWebImage

class CarouselItem: UIView {
    
    static let CAROUSEL_ITEM_NIB = "CarouselItem"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playButtonView: UIView!
    @IBOutlet weak var playButtonImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var subscribersCountLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    convenience init(backgroundImageViewURLString: String? = "",
                     channelNameText: String? = "Unknown", subscribersCountText: String) {
        self.init()
        let transformer = SDImageResizingTransformer(size: CGSize(width: 390, height: 183), scaleMode: .fill)
        self.channelNameLabel.text = channelNameText
        self.subscribersCountLabel.text = "\(String(describing: subscribersCountText)) subscribers"
        self.backgroundImageView.sd_setImage(with: URL(string: backgroundImageViewURLString ?? ""),
                                             placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.backgroundImageView.layer.cornerRadius = 10
        self.setGradientBackground(view: self.playButtonView)
    }
    
    //MARK: - Private
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(CarouselItem.CAROUSEL_ITEM_NIB,
                                 owner: self, options: nil)
        self.contentView.frame = bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
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
}
