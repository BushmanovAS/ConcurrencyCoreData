//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

final class StreetDBMapper: IDataBaseMapper {
    func toDomain(from entity: StreetEntity?) -> Street? {
        guard let entity = entity,
              let id = entity.id,
              let name = entity.name
        else {
            return nil
        }
        
        return Street(
            id: id,
            name: name,
            population: Int(entity.population)
        )
    }
    
    func toDomains(from entities: [StreetEntity]) -> [Street] {
        return entities.compactMap { toDomain(from: $0) }
    }
    
    func toEntity(from domain: Street, context: NSManagedObjectContext) throws -> StreetEntity {
        let entity = StreetEntity(context: context)
        entity.id = domain.id
        entity.name = domain.name
        entity.population = Int64(domain.population)
        
        return entity
    }
    
    func toEntities(from domains: [Street], context: NSManagedObjectContext) throws -> [StreetEntity] {
        return try domains.map { try toEntity(from: $0, context: context) }
    }
}
