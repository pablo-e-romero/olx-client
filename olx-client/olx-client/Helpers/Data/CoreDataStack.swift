//
//  CoreDataStack.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {

    static let sharedInstance = CoreDataStack()
    
    let modelURL: URL
    let model: NSManagedObjectModel
    let coordinator: NSPersistentStoreCoordinator
    
    // This is a read only context. It has to be used to present content
    let viewContext: NSManagedObjectContext
    
    // This context has to be used to process background operations, like JSON/Objects mapping
    let backgroundContext: NSManagedObjectContext
    
    override init() {
        
        self.modelURL = Bundle.main.url(forResource: "Model.momd/Model.mom", withExtension: nil)!
        self.model =  NSManagedObjectModel(contentsOf: self.modelURL)!
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        try! self.coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                 configurationName: nil,
                                                 at: CoreDataStack.databaseUrl(),
                                                 options: nil)
        
        self.viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.viewContext.persistentStoreCoordinator = self.coordinator
        
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.persistentStoreCoordinator = self.coordinator
        
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mergeChangesFromDidSaveNotification),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: self.backgroundContext)
    }
    
    static func databaseUrl() -> URL {
        let url = FileSystemHelper.documentsUrl()
        return url.appendingPathComponent("olx.sqlite")
    }
    
    func mergeChangesFromDidSaveNotification(notification: Notification) {
        self.viewContext.perform { 
            self.viewContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    func performBackgroundTask(_ perform: @escaping (NSManagedObjectContext) -> Void) {
        self.backgroundContext.perform { 
            perform(self.backgroundContext)
        }
    }
}
