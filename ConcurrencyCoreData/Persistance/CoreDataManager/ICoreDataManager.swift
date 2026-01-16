//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

public protocol ICoreDataManager {
    func saveChanges(_ context: NSManagedObjectContext) throws
    func newContext() -> NSManagedObjectContext

    func fetchMany<Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        fetchLimit: Int?,
        sortDescriptors: [NSSortDescriptor]?
    ) throws -> [Entity]

    func fetchOne<Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate
    ) throws -> Entity?

    func delete(
        entity: NSManagedObject.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?
    ) throws
    
    func updateField<Entity: NSManagedObject, Value>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        keyPath: ReferenceWritableKeyPath<Entity, Value>,
        value: Value
    ) throws
}

public extension ICoreDataManager {
    func fetchMany<Entity: NSManagedObject>(
        entity: Entity.Type,
        context: NSManagedObjectContext,
        predicate: NSPredicate? = nil,
        fetchLimit: Int? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [Entity] {
        try fetchMany(
            entity: entity,
            context: context,
            predicate: predicate,
            fetchLimit: fetchLimit,
            sortDescriptors: sortDescriptors
        )
    }
}
