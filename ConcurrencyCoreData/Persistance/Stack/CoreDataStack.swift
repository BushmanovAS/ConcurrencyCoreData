//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 05.09.2025.
//

import Foundation
import CoreData

final class CoreDataStack {
    // MARK: - Core Data Stack
    
    public static let shared = CoreDataStack()
    
    private let persistentContainer: NSPersistentContainer
    
    // COMMENT: - Общий background-контекст на все приложение. По задумке нужен для наблюдателя за БД
    // и для мержа разных контекстов, если они будут изменять одну таблицу. То есть мы работаем напрямую
    // только с дочерними контекстами. Main контекста нет и не будет, так как мы не тащим данные из БД
    // напрямую на экран
    private let backgroundContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ConcurrencyCoreData")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
            
            // COMMENT: - Путь до sql таблицы, если захочется поглядеть что в ней происходит
            print("✅ CoreData loaded: \(description.url?.absoluteString ?? "")")
        }
        
        backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Методы
    
    // COMMENT: - Создает новый дочерний контекст для CRUD операций. Создается 1 штука на сервис
    func newCRUDContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = backgroundContext
        childContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        childContext.automaticallyMergesChangesFromParent = true
        
        return childContext
    }
    
    // COMMENT: - Создает новый контекст для операций чтения
    func newReadContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        context.perform {
            guard context.hasChanges else { return }
            
            do {
                try context.save()
                
                // COMMENT: - так как появились дочерние контексты, то надо сохранять и родительский
                if let parent = context.parent {
                    self.saveContext(parent)
                }
            } catch {
                print("💩💩💩")
            }
        }
    }
}
