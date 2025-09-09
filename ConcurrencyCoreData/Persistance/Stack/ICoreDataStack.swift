//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation
import CoreData

protocol ICoreDataStack {
    func newCRUDContext() -> NSManagedObjectContext
    func newReadContext() -> NSManagedObjectContext
}
