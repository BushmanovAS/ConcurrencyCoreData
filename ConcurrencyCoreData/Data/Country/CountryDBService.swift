//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

protocol ICountryDBService {
    func saveCountries(_ country: [Country]) async throws
    func getCountries() async throws -> [Country]
    func deleteAllCountries() async throws
    func updateCountryName() async throws
}

actor CountryDBService: ICountryDBService {
    
    private let context: NSManagedObjectContext
    private let manager: ICoreDataManager
    private let countryMapper: any IDataBaseMapper<Country, CountryEntity> = CountryDBMapper()
    
    init(
        manager: ICoreDataManager = CoreDataManager.shared
    ) {
        self.manager = manager
        context = manager.newContext()
    }
    
    func saveCountries(_ country: [Country]) async throws {
        try await context.perform { [self] in
            _ = countryMapper.toEntities(from: country, context: context)
            try manager.saveChanges(context)
        }
    }
    
    func getCountries() async throws -> [Country] {
        try await context.perform { [self] in
            let entities = try manager
                .fetchMany(
                    entity: CountryEntity.self,
                    context: context,
                    predicate: nil,
                    sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
                )
            
            return countryMapper.toDomains(from: entities)
        }
    }
    
    func deleteAllCountries() async throws {
        try await context.perform { [self] in
            try manager
                .delete(
                    entity: CountryEntity.self,
                    context: context,
                    predicate: nil
                )
            
            try manager.saveChanges(context)
        }
    }
    
    func updateCountryName() async throws {
        try await context.perform { [self] in
            try manager
                .updateField(
                    entity: CountryEntity.self,
                    context: context,
                    predicate: nil,
                    keyPath: \.name,
                    value: "(.)(.)"
                )
        }
    }
    
    func updateCountryName<Value>(
        keyPath: ReferenceWritableKeyPath<Country, Value>,
        value: Value
    ) async throws {
        
        // тут придется маппить ключи
        // а тут придеся мапить значния
        
        try await context.perform { [self] in
            try manager
                .updateField(
                    entity: CountryEntity.self,
                    context: context,
                    predicate: nil,
                    keyPath: keyPath,
                    value: value
                )
        }
    }
}
