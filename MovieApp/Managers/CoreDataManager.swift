//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import Foundation
import CoreData


class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        guard let modelURL = Bundle.main.url(forResource: "MovieApp", withExtension: "momd") else {
            
            fatalError("Unable to Find Data Model")
            
        }
        
        
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            
            fatalError("Unable to Load Data Model")
            
        }
        
        
        
        return managedObjectModel
        
    }()
    
    
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        
        
        let fileManager = FileManager.default
        
        let storeName = "MovieApp.sqlite"
        
        
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        
        
        do {
            
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            
                            NSMigratePersistentStoresAutomaticallyOption : true]
            
            
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              
                                                              configurationName: nil,
                                                              
                                                              at: persistentStoreURL,
                                                              
                                                              options: options)
            
        } catch {
            
            //TODO: Fatal
            
            fatalError("Unable to Load Persistent Store")
            
        }
        return persistentStoreCoordinator
        
    }()

    // MARK: - Core Data Saving support
    public func saveContext (context: NSManagedObjectContext) {
        do {
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            try context.save()
        } catch {
        }
        
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MovieApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
