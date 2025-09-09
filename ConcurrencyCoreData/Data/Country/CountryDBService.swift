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
}

actor CountryDBService: ICountryDBService {
    
    private let writeContext: NSManagedObjectContext
    private let manager: ICoreDataManager
    
    init(
        stack: CoreDataStack = .shared,
        manager: ICoreDataManager = CoreDataManager.shared
    ) {
        self.writeContext = stack.newCRUDContext()
        self.manager = manager
    }
    
    func saveCountries(_ country: [Country]) async throws {
        try await manager
            .save(
                entity: CountryEntity.self,
                context: writeContext,
                domains: country,
                mapper: CountryDBMapper()
            )
    }
    
    func getCountries() async throws -> [Country] {
        try await manager
            .fetch(
                entity: CountryEntity.self,
                context: writeContext,
                sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
                returnsObjectsAsFaults: false,
                mapper: CountryDBMapper()
            )
    }
    
    func deleteAllCountries() async throws {
        try await manager.delete(entity: CountryEntity.self, context: writeContext, predicate: nil)
    }
}
