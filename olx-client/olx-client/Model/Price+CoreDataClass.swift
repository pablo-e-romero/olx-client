//
//  Price+CoreDataClass.swift
//  
//
//  Created by Pablo Romero on 1/25/17.
//
//

import Foundation
import CoreData

@objc(Price)
public class Price: NSManagedObject {

    static func create(withJson json: JSON,
                       context: NSManagedObjectContext) -> Price {
        
        let price = NSEntityDescription.insertNewObject(forEntityName: "Price",
                                                        into: context) as! Price
        
        price.update(withJson: json)
        return price
    }
    
    func update(withJson json: JSON) {
        
        if let amount = json["amount"] as? Int {
            self.amount = NSDecimalNumber(value: amount)
        } else {
            self.amount = 0
        }
        
        if let displayPrice = json["displayPrice"] as? String {
            self.displayPrice = displayPrice
        } else {
            self.displayPrice = nil
        }

    }
}
