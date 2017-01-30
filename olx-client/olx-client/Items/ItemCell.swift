//
//  ItemCell.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var cardContainerView: UIView!
    
    @IBOutlet weak var thumbnailImageView: UIRemoteImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupStyle()
    }
    
    func setupStyle() {
        
        self.cardContainerView.layer.cornerRadius = 10
        self.cardContainerView.clipsToBounds = true
        
        self.contentView.layer.shadowOffset = CGSize(width: 1.0,
                                                     height: 1.0)
        self.contentView.layer.shadowRadius = 2.0
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.2
        
        self.contentView.layer.rasterizationScale = UIScreen.main.scale
        self.contentView.layer.shouldRasterize = true;
        
        self.priceLabel.layer.cornerRadius = 5
        self.priceLabel.clipsToBounds = true
    }

    func update(withItem item: Item) {
        
        self.thumbnailImageView.setContent(url: item.mediumImageUrl())
        
        self.titleLabel.text = item.title
        
        if let displayLocation = item.displayLocation, !displayLocation.isEmpty {
            self.detailsLabel.text = "\(item.createdAt!.friendlyDescription()) in \(displayLocation)"
        } else {
            self.detailsLabel.text = item.createdAt!.friendlyDescription()
        }
        
        if let price = item.price?.displayPrice {
            self.priceLabel.isHidden = false
            self.priceLabel.text = price
        } else {
            self.priceLabel.isHidden = true
            self.priceLabel.text = ""
        }
   }

}
