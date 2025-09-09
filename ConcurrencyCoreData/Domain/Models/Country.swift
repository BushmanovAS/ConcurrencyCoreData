//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation

struct Country: Identifiable {
    let id: UUID
    let name: String
    let population: Int
    var cities: [City]
}
