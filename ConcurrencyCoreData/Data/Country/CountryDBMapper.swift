//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

final class CountryDBMapper: IDataBaseMapper {
    func toDomain(from entity: CountryEntity?) -> Country? {
        guard let entity = entity,
              let id = entity.id,
              let name = entity.name,
              let citiesSet = entity.cities as? Set<CityEntity>
        else {
            return nil
        }
        
        let cityMapper = CityDBMapper()
        let cities = citiesSet.compactMap { cityEntity in
            cityMapper.toDomain(from: cityEntity)
        }.sorted { $0.name < $1.name }
        
        return Country(
            id: id,
            name: name,
            population: Int(entity.population),
            cities: cities
        )
    }
    
    func toDomains(from entities: [CountryEntity]) -> [Country] {
        return entities.compactMap { toDomain(from: $0) }
    }
    
    func toEntity(from domain: Country, context: NSManagedObjectContext) throws -> CountryEntity {
        let entity = CountryEntity(context: context)
        entity.id = domain.id
        entity.name = domain.name
        entity.population = Int64(domain.population)
        
        let cityMapper = CityDBMapper()
        let cityEntities = try domain.cities.map { city in
            try cityMapper.toEntity(from: city, context: context)
        }
        
        entity.addToCities(NSSet(array: cityEntities))
        
        return entity
    }
    
    func toEntities(from domains: [Country], context: NSManagedObjectContext) throws -> [CountryEntity] {
        return try domains.map { try toEntity(from: $0, context: context) }
    }
}
