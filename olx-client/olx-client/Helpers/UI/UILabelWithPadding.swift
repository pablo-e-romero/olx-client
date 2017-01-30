//
//  UILabelWithPadding.swift
//  olx-client
//
//  Created by Pablo Romero on 1/29/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class UILabelWithPadding: UILabel {

    let padding: CGFloat = 4.0
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += 2 * padding
        return size
    }

}
