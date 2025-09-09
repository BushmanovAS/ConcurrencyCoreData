//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation

final class TestViewModel: ObservableObject {
    
    private let dataBase: ICountryDBService
    private let networkService: INetworkService
    
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    
    init() {
        networkService = NetworkService()
        dataBase = CountryDBService()
    }
    
    @MainActor
    func getCountries() async {
        isLoading = true
        
        do {
            let countriesFromWeb = try await networkService.getData1()
            try await dataBase.saveCountries(countriesFromWeb)
            var countriesFromDB = try await dataBase.getCountries()
            let sortedCountries = sortCountries(countriesFromDB)
            self.countries = sortedCountries
        } catch {
            print("add 💩")
        }
        
        isLoading = false
    }
    
    @MainActor
    func delete() async {
        isLoading = true
        
        do {
            try await dataBase.deleteAllCountries()
            self.countries = try await dataBase.getCountries()
        } catch {
            print("add 💩")
        }
        
        isLoading = false
    }
    
    @MainActor
    func change() async {
        isLoading = true
        
        do {
            try await dataBase.deleteAllCountries()
            let countriesFromWeb = try await networkService.getData2()
            try await dataBase.saveCountries(countriesFromWeb)
            var countriesFromDB = try await dataBase.getCountries()
            let sortedCountries = sortCountries(countriesFromDB)
            self.countries = sortedCountries
        } catch {
            print("add 💩")
        }
        
        isLoading = false
    }
    
    private func sortCountries(_ countries: [Country]) -> [Country] {
        var countries = countries
        
        for i in 0..<countries.count {
            countries[i].cities.sort { $0.name < $1.name }
            
            for j in 0..<countries[i].cities.count {
                countries[i].cities[j].streets.sort { $0.name < $1.name }
            }
        }
        
        return countries
    }
}
