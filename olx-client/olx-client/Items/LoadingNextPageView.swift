//
//  LoadingNextPageView.swift
//  olx-client
//
//  Created by Pablo Romero on 1/30/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class LoadingNextPageView: UIView {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    func setLoadingMode(_ on: Bool) {
        self.errorLabel.isHidden = on;
        self.spinner.isHidden = !on;
    }
    
    func setLoadingError(_ error: Error) {
        self.setLoadingMode(false)
        self.errorLabel.text = error.localizedDescription
    }
}

