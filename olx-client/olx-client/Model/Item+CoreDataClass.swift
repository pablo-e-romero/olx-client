//
//  Item+CoreDataClass.swift
//  
//
//  Created by Pablo Romero on 1/25/17.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    @discardableResult static func create(withJson json: JSON,
                                          context: NSManagedObjectContext) -> Item {
        
        let itemIdentifier = Item.identifier(fromJson: json)
        var item = Item.find(withIdentifier: itemIdentifier, context: context)
        
        if item == nil {
            item = NSEntityDescription.insertNewObject(forEntityName: "Item",
                                                       into: context) as? Item
        }
        
        item?.update(withJson: json)
        return item!
    }
    
    static func find(withIdentifier identifier: Int64,
                     context: NSManagedObjectContext) -> Item? {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %lld", identifier)
        
        var searchResults: Array<Item>?
        
        context.performAndWait {
            do {
                searchResults = try context.fetch(request)
            } catch {
                fatalError("Error with request: \(error)")
            }
        }
        
        return searchResults?.first
    }
    
    static func findAll(context: NSManagedObjectContext) -> [Item] {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        var searchResults: Array<Item>?
        
        context.performAndWait {
            do {
                searchResults = try context.fetch(request)
            } catch {
                fatalError("Error with request: \(error)")
            }
        }
        
        return searchResults ?? [Item]()
    }
    
    static func count(context: NSManagedObjectContext) -> Int {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        var count: Int = 0
        request.resultType = NSFetchRequestResultType.countResultType
        
        context.performAndWait {
            do {
                count = try context.count(for: request)
            } catch {
                fatalError("Error with request: \(error)")
            }
        }
        
        return count
    }
    
    static func last(context: NSManagedObjectContext) -> Item {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "sortValue", ascending: false)]
        
        var searchResults: Array<Item>?
        
        context.performAndWait {
            do {
                searchResults = try context.fetch(request)
            } catch {
                fatalError("Error with request: \(error)")
            }
        }
        
        return (searchResults?.first)!
    }
    
    static func isEmpty(context: NSManagedObjectContext) -> Bool {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.fetchLimit = 1
        
        var searchResults: Array<Item>?
        
        context.performAndWait {
            do {
                searchResults = try context.fetch(request)
            } catch {
                fatalError("Error with request: \(error)")
            }
        }
        
        if let searchResults = searchResults {
            return searchResults.count == 0
        } else {
            return true
        }
    }
    
    static func deleteAll(context: NSManagedObjectContext) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var searchResults: Array<Item>?
        
        context.performAndWait {
            do {
                searchResults = try context.fetch(request)
                
                for item in searchResults! {
                    context.delete(item)
                }
                
            } catch {
                fatalError("Error with request: \(error)")
            }
        }
    }
    
    static func identifier(fromJson json: JSON) -> Int64 {
        return json["id"] as! Int64
    }
    
    func update(withJson json: JSON) {
     
        if let details = json["description"] as? String {
            self.details = details
        } else {
            self.details = nil
        }
        
        if let title = json["title"] as? String {
            self.title = title
        } else {
            self.title = nil
        }
        
        if let displayLocation = json["displayLocation"] as? String {
            self.displayLocation = displayLocation
        } else {
            self.displayLocation = nil
        }
        
        if let fullImage = json["fullImage"] as? String {
            self.fullImage = fullImage
        } else {
            self.fullImage = nil
        }
        
        if let identifier = json["id"] as? Int64 {
            self.identifier = identifier
        } else {
            self.identifier = 0
        }
        
        if let imageColor = json["imageColor"] as? String {
            self.imageColor = imageColor
        } else {
            self.imageColor = nil
        }
        
        if let mediumImage = json["mediumImage"] as? String {
            self.mediumImage = mediumImage
        } else {
            self.mediumImage = nil
        }
        
        if let thumbnail = json["thumbnail"] as? String {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = nil
        }
        
        if let date = json["date"] as? JSON {
            if let timestamp = date["timestamp"] as? String {
                self.createdAt = NSDate.date(withISO860String: timestamp)
            } else {
                self.createdAt = nil
            }
        } else {
            self.createdAt = nil
        }
    }
    
    func mediumImageUrl() -> URL? {
        if let mediumImage = self.mediumImage, !mediumImage.isEmpty {
            return URL(string: self.mediumImage!)
        } else {
            return nil;
        }
    }

}
