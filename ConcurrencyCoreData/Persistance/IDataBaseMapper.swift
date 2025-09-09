//
//  File1.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

protocol IDataBaseMapper<Domain, Entity> {
    associatedtype Domain
    associatedtype Entity: NSManagedObject
    
    func toDomain(from entity: Entity?) -> Domain?
    func toDomains(from entities: [Entity]) -> [Domain]
    
    @discardableResult
    func toEntity(from domain: Domain, context: NSManagedObjectContext) throws -> Entity
    @discardableResult
    func toEntities(from domains: [Domain], context: NSManagedObjectContext) throws -> [Entity]
}
