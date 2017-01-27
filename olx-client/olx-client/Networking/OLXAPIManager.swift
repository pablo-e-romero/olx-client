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
    let defaultPageSize: UInt = 25
    let baseUrl = URL(string: "http://api-v2.olx.com")!
    
    func requestItems(searchTerm: String = "", offset: UInt = 0,
                      completionHandler: @escaping (Bool?, Error?) -> Void) {
    
        let url = baseUrl.appendingPathComponent("items")
        var params = [String:Any]()
        
        params["location"] = "www.olx.com.ar"
        params["searchTerm"] = searchTerm
        params["pageSize"] = self.defaultPageSize
        params["offset"] = offset
        
        NetworkHelper.request(url, params: params) { (json: JSON?, error: Error?) in
            
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else {
                self.processItemsResponse(json: json!,
                                          offset: offset,
                                          completionHandler: { (reachedLastPage: Bool) in
                                            DispatchQueue.main.async {
                                                completionHandler(reachedLastPage, nil)
                                            }
                })
            }
        }
    }
    
    private func processItemsResponse(json: JSON,
                                      offset: UInt,
                                      completionHandler: @escaping ((Bool) -> Void)) {
        
        CoreDataStack.sharedInstance.performBackgroundTask { (context: NSManagedObjectContext) in
            
            let resetLocalData: Bool = (offset == 0)
            var newItems = Set<Item>()
         
            if let itemJsonsList = json["data"] as? [JSON] {
                
                var serverSort = offset
                
                for itemJson in itemJsonsList {
                    
                    let item = Item.create(withJson: itemJson,
                                           context: context)
                    item.serverSort = Int16(serverSort)
                    serverSort += 1
                    
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
            
            let reachedLastPage = UInt(newItems.count) < self.defaultPageSize
            
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
            
            completionHandler(reachedLastPage)
        }
    }
}
