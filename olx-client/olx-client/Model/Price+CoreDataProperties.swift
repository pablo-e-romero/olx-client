//
//  Price+CoreDataProperties.swift
//  
//
//  Created by Pablo Romero on 1/25/17.
//
//

import Foundation
import CoreData


extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price");
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var displayPrice: String?
    @NSManaged public var item: Item?

}
