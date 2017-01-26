//
//  UIAlertController+Simplified.swift
//  olx-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    static func presentAlert(withError error: Error,
                             overViewController vc: UIViewController) {
        
        let alertController = UIAlertController(title: nil,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
      
        let okButton = UIAlertAction(title: "OK",
                                     style: .cancel,
                                     handler: nil)
        alertController.addAction(okButton)
        
        vc.present(alertController, animated: true, completion: nil)
    }

}
