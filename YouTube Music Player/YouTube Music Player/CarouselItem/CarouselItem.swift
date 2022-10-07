//
//  CarouselItem.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 04.10.2022.
//

import UIKit

class CarouselItem: UIView {
    
    static let CAROUSEL_ITEM_NIB = "CarouselItem"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    convenience init(titleText: String? = "", background: UIColor? = .red) {
        self.init()
        centerLabel.text = titleText
        backgroundView.backgroundColor = background
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(CarouselItem.CAROUSEL_ITEM_NIB, owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
