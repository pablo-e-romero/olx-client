//
//  OLXAPIManager.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class OLXAPIManager: NSObject {
    
    static let sharedInstance = OLXAPIManager()
    var network: NetworkHelper
    let defaultPageSize: UInt = 25
    let baseUrl = URL(string: "http://api-v2.olx.com")!
    
    override init() {
        self.network = NetworkHelper()
        super.init()
    }
    
    func requestItems(searchTerm: String = "", atPage page: UInt = 0,
                      completionHandler: @escaping (Any?, Error?) -> Void) {
    
        let url = baseUrl.appendingPathComponent("items")
        var params = [String:Any]()
        
        params["location"] = "www.olx.com.ar"
        params["searchTerm"] = searchTerm
        params["pageSize"] = self.defaultPageSize
        params["offset"] = page * self.defaultPageSize
        
        self.network.request(url, params: params) { (json: Any?, error: Error?) in
            
            print("json \(json) error \(error)")
            
        }
    }
    
}
