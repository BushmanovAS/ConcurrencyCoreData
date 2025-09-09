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

// COMMENT: - ДБ сервисы стали акторами, это позволяет разруливать очередность доступа в пределах одного контекста
actor CountryDBService: ICountryDBService {
    
    // COMMENT: - У каждого ДБ сервиса появился свой приватный контекст, для CRUD операций,
    // для операций чтения каждый раз создается новый контекст
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
                // COMMENT: - мапперы так же создаются при каждом вызове, с одной стороны
                // выглядит не очень, с другой стороны убирает все приколы с этим связанные.
                // Такой маппер как тут, можно смело выносить в переменную, так как он не
                // содежит сложной логики и не хранит состояния
                mapper: CountryDBMapper()
            )
    }
    
    func getCountries() async throws -> [Country] {
        try await manager
            .fetch(
                entity: CountryEntity.self,
                // COMMENT: - несмотря на то, что выше я написал, что для чтения создается новый контекст, здесь
                // я использую тот же изолированный, так как если дернуть save, а потом сразу fetch, данные в
                // контекстах не успевают помержиться. Это проверяется через Task.sleep. Варианты: сделать все операции
                // через один контекст, как тут, либо же при save не ходить в БД, а брать то что сейвили. Это актуально
                // только для этого тестового апа, так как в обычной ситуации обычно нет смысла дергать save, а потом сразу fetch
                context: writeContext,
                // COMMENT: - вот эта штука вроде как гораздо выгоднее, чем обычная сортировка, но при этом мы не можем прокинуть
                // ее на "детей", что печально, но что поделать)
                sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
                returnsObjectsAsFaults: false,
                mapper: CountryDBMapper()
            )
    }
    
    func deleteAllCountries() async throws {
        try await manager.delete(entity: CountryEntity.self, context: writeContext, predicate: nil)
    }
}
