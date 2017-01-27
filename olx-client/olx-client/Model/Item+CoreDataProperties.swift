//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Pablo Romero on 1/25/17.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var serverSort: Int16
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var imageColor: String?
    @NSManaged public var identifier: Int64
    @NSManaged public var fullImage: String?
    @NSManaged public var mediumImage: String?
    @NSManaged public var title: String?
    @NSManaged public var displayLocation: String?
    @NSManaged public var price: Price?

}
