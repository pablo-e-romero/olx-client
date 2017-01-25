//
//  NetworkHelper.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import Alamofire

class NetworkHelper: NSObject {

    func request(_ url: URL,
                 params: [String: Any],
                 completionHandler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, parameters: params).responseJSON { response in
            completionHandler(response.result.value,
                              response.error)
        }
    }
}
