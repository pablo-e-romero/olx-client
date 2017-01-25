//
//  OLXAPIManager.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import CoreData

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
                      completionHandler: @escaping (Error?) -> Void) {
    
        let url = baseUrl.appendingPathComponent("items")
        var params = [String:Any]()
        let offset: UInt = page * self.defaultPageSize
        
        params["location"] = "www.olx.com.ar"
        params["searchTerm"] = searchTerm
        params["pageSize"] = self.defaultPageSize
        params["offset"] = offset
        
        self.network.request(url, params: params) { (json: JSON?, error: Error?) in
            
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            } else {
                self.processItemsResponse(json: json!,
                                          resetLocalData: (page == 0),
                                          offset: offset,
                                          completionHandler: {
                                            DispatchQueue.main.async {
                                                completionHandler(nil)
                                            }
                })
            }
        }
    }
    
    private func processItemsResponse(json: JSON,
                                      resetLocalData: Bool,
                                      offset: UInt,
                                      completionHandler: @escaping ((Void) -> Void)) {
        
        CoreDataStack.sharedInstance.performBackgroundTask { (context: NSManagedObjectContext) in
            
            var newItems = Set<Item>()
        
            if let itemJsonsList = json["data"] as? [JSON] {
                
                for itemJson in itemJsonsList {
                    
                    let item = Item.create(withJson: itemJson,
                                           context: context)
                    
                    if let priceJson = itemJson["price"] as? JSON {
                        if let price = item.price {
                            price.update(withJson: priceJson)
                        } else {
                            let price = Price.create(withJson: priceJson,
                                                     context: context)
                            item.price = price
                        }
                    } else {
                        item.price = nil
                    }
                    
                    newItems.insert(item)
                }
            }
            
            if (resetLocalData)
            {
                // Remove only the ones that aren't in the news set
                let items = Item.findAll(context: context)
                
                for item in items {
                    if !newItems.contains(item) {
                        context.delete(item)
                    }
                }
            }
            
            try! context.save()
            
            completionHandler()
        }
    }
}
