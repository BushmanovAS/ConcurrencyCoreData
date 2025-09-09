//
//  City.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation

struct City: Identifiable {
    let id: UUID
    let name: String
    let population: Int
    var streets: [Street]
}
