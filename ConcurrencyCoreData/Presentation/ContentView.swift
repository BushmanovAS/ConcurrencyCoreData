//
//  ContentView.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 05.09.2025.
//

import SwiftUI
import CoreData

struct TestView: View {
    
    @StateObject var viewModel = TestViewModel()
    
    var body: some View {
        VStack {
            HStack {
                button("Add") {
                    Task {
                        await viewModel.getCountries()
                    }
                }
                
                button("Delete") {
                    Task {
                        await viewModel.delete()
                    }
                }
                
                button("Change") {
                    Task {
                        await viewModel.change()
                    }
                }
                
                button("Update Names") {
                    Task {
                        await viewModel.updateCountriesNames()
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            List(viewModel.countries) { country in
                VStack(alignment: .leading) {
                    Text(country.name)
                        .font(.system(size: 20.0, weight: .bold))
                    
                    VStack(alignment: .leading) {
                        ForEach(country.cities) { city in
                            Text(city.name)
                                .font(.system(size: 17.0, weight: .semibold))
                            
                            VStack(alignment: .leading) {
                                ForEach(city.streets) { street in
                                    Text(street.name)
                                        .font(.system(size: 13.0))
                                }
                            }
                            .padding(.leading)
                        }
                    }
                    .padding(.leading)
                }
                
            }
        }
    }
    
    private func button(_ title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color.blue)
                .frame(height: 40.0)
                .overlay {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
        }
    }
}

#Preview {
    TestView()
}
