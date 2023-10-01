//
//  MainWeatherViewModel.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import SwiftUI

final class MainWeatherViewModel: ObservableObject {
    
    @Published var loadingState: LoadingState = .loaded
    @Published var city: String
    @Published var temperature: CGFloat = 0.0
    
    private let dataService: DataServicing
    
    init(dataService: DataServicing) {
        self.dataService = dataService
        self.city = ""
    }
    
    @MainActor
    func getWeather() async {
        loadingState = .loading
            do {
                let weather = try await dataService.fetchWeather(city: city)
                temperature = weather.main.temp
                loadingState = .loaded
            } catch {
                loadingState = .error

            }
    }
}
