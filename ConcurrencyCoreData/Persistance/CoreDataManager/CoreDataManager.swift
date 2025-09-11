//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

final class CoreDataManager: ICoreDataManager {

    
    public static let shared = CoreDataManager()
    
    enum UpdateStrategy {
        case fullUpdate
        case partialUpdate((NSManagedObject, NSManagedObject) -> Void)
    }
    
    private let stack: CoreDataStack
    
    private init() {
        self.stack = CoreDataStack.shared
    }
    
    func fetch<Domain, Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        fetchLimit: Int?,
        fetchBatchSize: Int?,
        sortDescriptors: [NSSortDescriptor]?,
        propertiesToFetch: [String]?,
        returnsObjectsAsFaults: Bool,
        shouldRefreshRefetchedObjects: Bool,
        mapper: some IDataBaseMapper<Domain, Entity>
    ) async throws -> [Domain] {
        let array = try await context.perform {
            let fetchRequest = self.makeFetchRequest(
                entity: entity,
                predicate: predicate,
                fetchLimit: fetchLimit,
                fetchBatchSize: fetchBatchSize,
                sortDescriptors: sortDescriptors,
                propertiesToFetch: propertiesToFetch,
                returnsObjectsAsFaults: returnsObjectsAsFaults,
                shouldRefreshRefetchedObjects: shouldRefreshRefetchedObjects
            )
            let entities = try context.fetch(fetchRequest)
            
            return mapper.toDomains(from: entities)
        }
        
        return array
    }
    
    func fetch<Domain, Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        fetchLimit: Int?,
        fetchBatchSize: Int?,
        sortDescriptors: [NSSortDescriptor]?,
        propertiesToFetch: [String]?,
        returnsObjectsAsFaults: Bool,
        shouldRefreshRefetchedObjects: Bool,
        mapper: some IDataBaseMapper<Domain, Entity>
    ) async throws -> Domain? {
        let domain = try await context.perform {
            let fetchRequest = self.makeFetchRequest(
                entity: entity,
                predicate: predicate,
                fetchLimit: fetchLimit,
                fetchBatchSize: fetchBatchSize,
                sortDescriptors: sortDescriptors,
                propertiesToFetch: propertiesToFetch,
                returnsObjectsAsFaults: returnsObjectsAsFaults,
                shouldRefreshRefetchedObjects: shouldRefreshRefetchedObjects
            )
            let entities = try context.fetch(fetchRequest)
            
            return mapper.toDomain(from: entities.first)
        }
        
        return domain
    }
    
    func save<Domain, Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        domains: [Domain],
        mapper: some IDataBaseMapper<Domain, Entity>
    ) async throws {
        try await context.perform {
            
            _ = try mapper.toEntities(from: domains, context: context)
            
            if context.hasChanges {
                try context.save()
                
                if let parent = context.parent {
                    try parent.save()
                }
            }
        }
    }
    
    func delete(
        entity: NSManagedObject.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?
    ) async throws {
        let fetchRequest = makeFetchRequest(
            entity: entity,
            predicate: predicate
        )
        
        try await context.perform {
            let entities = try context.fetch(fetchRequest)
            
            for entity in entities {
                context.delete(entity)
            }
            
            if context.hasChanges {
                try context.save()
                
                if let parent = context.parent {
                    try parent.save()
                }
            }
        }
    }
    
    // COMMENT: - не тестил эту штуку, развлекайтесь)
    func updateFields<Entity: NSManagedObject>(
        entityType: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate,
        fieldsToUpdate: [String: Any]
    ) async throws {
        try await context.perform {
            let batchUpdate = NSBatchUpdateRequest(entityName: String(describing: entityType))
            batchUpdate.predicate = predicate
            batchUpdate.propertiesToUpdate = fieldsToUpdate
            batchUpdate.resultType = .updatedObjectIDsResultType
            
            _ = try context.execute(batchUpdate) as! NSBatchUpdateResult
        }
    }
    
    func update<Domain, Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        mapper: some IDataBaseMapper<Domain, Entity>,
        domain: Domain,
        updateStrategy: UpdateStrategy
    ) async throws {
        // COMMENT: - performAndWait превратился в нормальный perform и теперь работает асинхроно
        try await context.perform {
            // COMMENT: - fetchRequest не создает еще одно preform замыкания, и для исключения
            // всяких приколов создается внутри блока perform
            let request = self.makeFetchRequest(
                entity: entity,
                predicate: predicate,
                fetchLimit: 1
            )
            
            let existingEntity = try context.fetch(request).first
            
            switch updateStrategy {
            case .fullUpdate:
                if let existingEntity {
                    context.delete(existingEntity)
                }
                
                _ = try mapper.toEntity(from: domain, context: context)
                
            case .partialUpdate(let updater):
                if let existingEntity = existingEntity {
                    let newEntity = try mapper.toEntity(from: domain, context: context)
                    updater(existingEntity, newEntity)
                } else {
                    _ = try mapper.toEntity(from: domain, context: context)
                }
            }
            
            if context.hasChanges {
                try context.save()
                
                if let parent = context.parent {
                    try parent.save()
                }
            }
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
    ) -> NSFetchRequest<Entity> {
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: entity.self))
        fetchRequest.predicate = predicate
        
        if let fetchLimit { fetchRequest.fetchLimit = fetchLimit }
        if let fetchBatchSize { fetchRequest.fetchBatchSize = fetchBatchSize }
        if let sortDescriptors { fetchRequest.sortDescriptors = sortDescriptors }
        if let propertiesToFetch { fetchRequest.propertiesToFetch = propertiesToFetch }
        
        // COMMENT: - оказывается fault объекты можно тупо отключить 🤷‍♂️
        fetchRequest.returnsObjectsAsFaults = returnsObjectsAsFaults
        // COMMENT: - позволяет реактивно, прямо во время запроса подтягивать изменения из общего
        // контекста, если они там появлись. Отключил от греха подальше :D
        fetchRequest.shouldRefreshRefetchedObjects = shouldRefreshRefetchedObjects
        
        return fetchRequest
    }
}
