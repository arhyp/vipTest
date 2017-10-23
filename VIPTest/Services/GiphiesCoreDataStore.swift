//
//  GiphiesCoreDataStore.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright © 2017 KoshelGROUP. All rights reserved.
//

import Foundation
import CoreData

class GiphiesCoreDataStore: GIPHIESStoreProtocol, GIPHIESStoreUtilityProtocol
{
  

    // MARK: - Managed object contexts
    
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    
    // MARK: - Object lifecycle
    
    init()
    {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "VIPTest", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("CleanStore.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
    }
    
    deinit
    {
        do {
            try self.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    // MARK: - CRUD operations - Optional error
    
    func fetchGIPHIES(completionHandler: @escaping ([GIPHY], GIPHIESStoreError?) -> Void)
    {
        privateManagedObjectContext.perform {
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedGIPHY")
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedGIPHY]
                let giphies = results.map { $0.toGIPHY() }
                completionHandler(giphies, nil)
            } catch {
                completionHandler([], GIPHIESStoreError.CannotFetch("Cannot fetch giphies"))
            }
        }
    }
    
    func fetchGIPHY(id: String, completionHandler: @escaping (GIPHY?, GIPHIESStoreError?) -> Void)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedGIPHY")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedGIPHY]
                if let giphy = results.first?.toGIPHY() {
                    completionHandler(giphy, nil)
                } else {
                    completionHandler(nil, GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)"))
                }
            } catch {
                completionHandler(nil, GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)"))
            }
        }
    }
//
    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping (GIPHY?, GIPHIESStoreError?) -> Void)
    {
        privateManagedObjectContext.perform {
            do {
                let managedGIPHY = NSEntityDescription.insertNewObject(forEntityName: "ManagedGIPHY", into: self.privateManagedObjectContext) as! ManagedGIPHY
                var giphy = giphyToCreate
                self.generateGIPHYID(giphy: &giphy)
                
                managedGIPHY.fromGIPHY(giphy: giphy)
                try self.privateManagedObjectContext.save()
                completionHandler(giphy, nil)
            } catch {
                completionHandler(nil, GIPHIESStoreError.CannotCreate("Cannot create giphy with id \(String(describing: giphyToCreate.id))"))
            }
        }
    }

    // MARK: - CRUD operations - Generic enum result type

    func fetchGIPHIES(completionHandler: @escaping GIPHIESStoreFetchGiphiesCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedGIPHY")
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedGIPHY]
                let giphies = results.map { $0.toGIPHY() }
                completionHandler(GIPHIESStoreResult.Success(result: giphies))
            } catch {
                completionHandler(GIPHIESStoreResult.Failure(error: GIPHIESStoreError.CannotFetch("Cannot fetch giphies")))
            }
        }
    }

    func fetchGIPHY(id: String, completionHandler: @escaping GIPHIESStoreFetchGiphyCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedGIPHY")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedGIPHY]
                if let giphy = results.first?.toGIPHY() {
                    completionHandler(GIPHIESStoreResult.Success(result: giphy))
                } else {
                    completionHandler(GIPHIESStoreResult.Failure(error: GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)")))
                }
            } catch {
                completionHandler(GIPHIESStoreResult.Failure(error: GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)")))
            }
        }
    }

    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping GIPHIESStoreCreateGiphyCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let managedGIPHY = NSEntityDescription.insertNewObject(forEntityName: "ManagedGIPHY", into: self.privateManagedObjectContext) as! ManagedGIPHY
                var giphy = giphyToCreate
                self.generateGIPHYID(giphy: &giphy)
                
                managedGIPHY.fromGIPHY(giphy: giphy)
                try self.privateManagedObjectContext.save()
                completionHandler(GIPHIESStoreResult.Success(result: giphy))
            } catch {
                let error = GIPHIESStoreError.CannotCreate("Cannot create giphy with id \(String(describing: giphyToCreate.id))")
                completionHandler(GIPHIESStoreResult.Failure(error: error))
            }
        }
    }


    // MARK: - CRUD operations - Inner closure

    func fetchGIPHIES(completionHandler: @escaping (() throws -> [GIPHY]) -> Void)
    {
        mainManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedGIPHY")
                let results = try self.mainManagedObjectContext.fetch(fetchRequest) as! [ManagedGIPHY]
                let giphies = results.map { $0.toGIPHY() }
                completionHandler { return giphies }
            } catch {
                completionHandler { throw GIPHIESStoreError.CannotFetch("Cannot fetch giphies") }
            }
        }
    }

    func fetchGIPHY(id: String, completionHandler: @escaping (() throws -> GIPHY?) -> Void)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedGIPHY")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedGIPHY]
                if let giphy = results.first?.toGIPHY() {
                    completionHandler { return giphy }
                } else {
                    throw GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)")
                }
            } catch {
                completionHandler { throw GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)") }
            }
        }
    }

    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping (() throws -> GIPHY?) -> Void)
    {
        mainManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedGIPHY")
                fetchRequest.predicate = NSPredicate(format: "id == %@", giphyToCreate.id!)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedGIPHY]
                if results.first != nil {
                    completionHandler { throw GIPHIESStoreError.CannotCreate("Cannot create giphy with id \(String(describing: giphyToCreate.id))")
                        
                    }
                    return;
                }
                let managedGIPHY = NSEntityDescription.insertNewObject(forEntityName: "ManagedGIPHY", into: self.mainManagedObjectContext) as! ManagedGIPHY
                let giphy = giphyToCreate

                managedGIPHY.fromGIPHY(giphy: giphy)
                try self.mainManagedObjectContext.save()
                completionHandler { return giphy }
            } catch {
                completionHandler { throw GIPHIESStoreError.CannotCreate("Cannot create giphy with id \(String(describing: giphyToCreate.id))") }
            }
        }
    }

    func save(){
       try? self.mainManagedObjectContext.save()
    }
}
