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
    
    @IBOutlet weak var priceLabelWidthConstraint: NSLayoutConstraint!
    
    
    // Important: these values have to be in sync with IB
    static let padding: CGFloat = 8.0
    static let titleFont = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBold)
    static let thumbnailHeight: CGFloat = 242.0
    static let detailsHeight: CGFloat = 15.0
    static let priceHeight: CGFloat = 21.0
    static let contentViewPadding: CGFloat = 1.0
    // --------------------------------------------------
    
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
            
            // Resize width
            let maxSize = CGSize(width: UIScreen.main.bounds.width - 6 * ItemCell.padding,
                                 height: self.priceLabel.frame.size.height)
            
            let newSize = self.priceLabel.sizeThatFits(maxSize)
            
            self.priceLabelWidthConstraint.constant = newSize.width + 2 * ItemCell.padding
  
        } else {
            self.priceLabel.isHidden = true
            self.priceLabel.text = ""
        }
   }
    
    static func neededHeight(forItem item: Item) -> CGFloat {
       
        var height: CGFloat = 2 * padding + thumbnailHeight + padding
        
        if let title = item.title {
          
            let maxSize = CGSize(width: UIScreen.main.bounds.width - 4 * padding,
                                 height: .greatestFiniteMagnitude)
        
            let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
     
            let attributedTitle = NSAttributedString(string: title,
                                                 attributes: [NSFontAttributeName: titleFont])
        
            let titleRect = attributedTitle.boundingRect(with: maxSize,
                                                         options: options,
                                                         context: nil)
            
            height += ceil(titleRect.height)
        }
        
        height += padding
        height += detailsHeight
        
        height += padding
        height += priceHeight
        height += padding
        height += contentViewPadding
        
        return height
    }
}
