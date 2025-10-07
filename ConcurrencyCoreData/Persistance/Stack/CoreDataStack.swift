//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 05.09.2025.
//

import Foundation
import CoreData

final class CoreDataStack: ICoreDataStack {
    // MARK: - Properties
    
    public static let shared = CoreDataStack()

    private let persistentContainer: NSPersistentContainer
    private var backgroundContext: NSManagedObjectContext?

    // MARK: - Init

    private init() {
        persistentContainer = NSPersistentContainer(name: "ConcurrencyCoreData")
        persistentContainer.loadPersistentStores { _, error in
            if let loadError = error {
                do {
                    try self.clearDatabase(in: self.persistentContainer)
                } catch {
                    fatalError("Core Data store failed to load: \(loadError)")
                }
            }

            let context = self.persistentContainer.newBackgroundContext()
            context.automaticallyMergesChangesFromParent = true
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            self.backgroundContext = context
        }
    }

    func newCRUDContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = backgroundContext
        childContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        childContext.automaticallyMergesChangesFromParent = true

        return childContext
    }

    func newReadContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}

private extension CoreDataStack {
    func clearDatabase(in container: NSPersistentContainer) throws {
        guard let url = container.persistentStoreDescriptions.first?.url else { return }

        let persistentStoreCoordinator = container.persistentStoreCoordinator

        try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
        try persistentStoreCoordinator.addPersistentStore(
            ofType: NSSQLiteStoreType,
            configurationName: nil,
            at: url,
            options: nil
        )
    }
}

