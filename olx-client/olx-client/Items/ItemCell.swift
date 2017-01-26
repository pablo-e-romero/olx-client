//
//  ItemCell.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func update(withItem item: Item) {
        self.titleLabel.text = item.title
    }
}
