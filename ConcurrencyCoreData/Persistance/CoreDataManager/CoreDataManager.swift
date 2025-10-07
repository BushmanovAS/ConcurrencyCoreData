//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

final class CoreDataManager: ICoreDataManager {
    // MARK: - Properties

    private let stack: ICoreDataStack = CoreDataStack.shared
    
    public static let shared = CoreDataManager()

    // MARK: - Init

    private init () {}

    // MARK: - Functions

    func saveChanges(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }

        try context.save()

        if let parent = context.parent {
            try parent.save()
        }
    }

    func newContext() -> NSManagedObjectContext {
        stack.newCRUDContext()
    }

    func fetchMany<Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        fetchLimit: Int?,
        sortDescriptors: [NSSortDescriptor]?,
    ) throws -> [Entity] {
        let fetchRequest = makeFetchRequest(
            entity: entity,
            predicate: predicate,
            fetchLimit: fetchLimit,
            sortDescriptors: sortDescriptors,
        )

        return try context.fetch(fetchRequest)
    }

    func fetchOne<Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate
    ) throws -> Entity? {
        let fetchRequest = makeFetchRequest(
            entity: entity,
            predicate: predicate
        )

        let entities = try context.fetch(fetchRequest)

        return entities.first
    }

    func delete(
        entity: NSManagedObject.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?
    ) throws {
        let fetchRequest = makeFetchRequest(
            entity: entity,
            predicate: predicate
        )

        let entities = try context.fetch(fetchRequest)

        for entity in entities {
            context.delete(entity)
        }
    }
}

private extension CoreDataManager {
    func makeFetchRequest<Entity: NSManagedObject>(
        entity: Entity.Type,
        predicate: NSPredicate? = nil,
        fetchLimit: Int? = nil,
        fetchBatchSize: Int? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        propertiesToFetch: [String]? = nil,
        returnsObjectsAsFaults: Bool = false,
        shouldRefreshRefetchedObjects: Bool = false,
        resultType: NSFetchRequestResultType? = nil,
        returnsDistinctResults: Bool = false
    ) -> NSFetchRequest<Entity> {
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: entity.self))
        fetchRequest.predicate = predicate

        if let fetchLimit { fetchRequest.fetchLimit = fetchLimit }
        if let fetchBatchSize { fetchRequest.fetchBatchSize = fetchBatchSize }
        if let sortDescriptors { fetchRequest.sortDescriptors = sortDescriptors }
        if let propertiesToFetch { fetchRequest.propertiesToFetch = propertiesToFetch }
        if let resultType { fetchRequest.resultType = resultType }

        fetchRequest.returnsDistinctResults = returnsDistinctResults
        fetchRequest.returnsObjectsAsFaults = returnsObjectsAsFaults
        fetchRequest.shouldRefreshRefetchedObjects = shouldRefreshRefetchedObjects

        return fetchRequest
    }
}
