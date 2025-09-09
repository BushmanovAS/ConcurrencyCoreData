//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

protocol ICoreDataManager {
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
    ) async throws -> [Domain]
    
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
    ) async throws -> Domain?
    
    func save<Domain, Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        domains: [Domain],
        mapper: some IDataBaseMapper<Domain, Entity>
    ) async throws
    
    func delete(
        entity: NSManagedObject.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?
    ) async throws
    
    func updateFields<Entity: NSManagedObject>(
        entityType: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate,
        fieldsToUpdate: [String: Any]
    ) async throws
    
    func update<Domain, Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        mapper: some IDataBaseMapper<Domain, Entity>,
        domain: Domain,
        updateStrategy: CoreDataManager.UpdateStrategy
    ) async throws
}

extension ICoreDataManager {
    func fetch<Domain, Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate? = nil,
        fetchLimit: Int? = nil,
        fetchBatchSize: Int? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        propertiesToFetch: [String]? = nil,
        returnsObjectsAsFaults: Bool = true,
        shouldRefreshRefetchedObjects: Bool = false,
        mapper: some IDataBaseMapper<Domain, Entity>
    ) async throws -> [Domain] {
        try await fetch(
            entity: entity,
            context: context,
            predicate: predicate,
            fetchLimit: fetchLimit,
            fetchBatchSize: fetchBatchSize,
            sortDescriptors: sortDescriptors,
            propertiesToFetch: propertiesToFetch,
            returnsObjectsAsFaults: returnsObjectsAsFaults,
            shouldRefreshRefetchedObjects: shouldRefreshRefetchedObjects,
            mapper: mapper
        )
    }
}
