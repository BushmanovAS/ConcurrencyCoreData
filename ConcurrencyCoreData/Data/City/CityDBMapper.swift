//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

final class CityDBMapper: IDataBaseMapper {
    func toDomain(from entity: CityEntity?) -> City? {
        guard let entity = entity,
              let id = entity.id,
              let name = entity.name,
              let streetsSet = entity.streets as? Set<StreetEntity>
        else {
            return nil
        }
        
        let streetMapper = StreetDBMapper()
        let streets = streetsSet.compactMap { streetEntity in
            streetMapper.toDomain(from: streetEntity)
        }.sorted { $0.name < $1.name }
        
        return City(
            id: id,
            name: name,
            population: Int(entity.population),
            streets: streets
        )
    }
    
    func toDomains(from entities: [CityEntity]) -> [City] {
        return entities.compactMap { toDomain(from: $0) }
    }
    
    func toEntity(from domain: City, context: NSManagedObjectContext) throws -> CityEntity {
        let entity = CityEntity(context: context)
        entity.id = domain.id
        entity.name = domain.name
        entity.population = Int64(domain.population)
        
        let streetMapper = StreetDBMapper()
        let streetEntities = try domain.streets.map { street in
            try streetMapper.toEntity(from: street, context: context)
        }
        
        entity.addToStreets(NSSet(array: streetEntities))
        
        return entity
    }
    
    func toEntities(from domains: [City], context: NSManagedObjectContext) throws -> [CityEntity] {
        return try domains.map { try toEntity(from: $0, context: context) }
    }
}
