//
//  NetworkHelper.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import Alamofire

typealias JSON = [String: Any]

class NetworkHelper: NSObject {

    func request(_ url: URL,
                 params: [String: Any],
                 completionHandler: @escaping (JSON?, Error?) -> Void) {
        Alamofire.request(url, parameters: params).responseData { response in
            if response.error != nil {
                completionHandler(nil, response.error)
            } else {
                let json = try! JSONSerialization.jsonObject(with: response.result.value!) as? JSON
                completionHandler(json, nil)
            }
        }
    }
}
