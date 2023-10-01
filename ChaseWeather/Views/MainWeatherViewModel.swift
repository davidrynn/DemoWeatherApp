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
    @Published var iconURL: URL?
    @Published var units: Units = .imperial
    
    private let dataService: DataServicing
    
    init(dataService: DataServicing) {
        self.dataService = dataService
        self.city = ""
    }
    
    @MainActor
    func getWeather() async {
        loadingState = .loading
            do {
                let weather = try await dataService.fetchWeather(city: city, units: units)
                temperature = weather.main.temp
                loadingState = .loaded
                if let weatherIcon = weather.weather.first?.icon {
                    iconURL = dataService.buildIconUrl(iconId: weatherIcon)
                } else {
                    iconURL = nil
                }
            } catch {
                loadingState = .error
            }
    }
    
    func reset() {
        city = ""
        temperature = 0.0
        iconURL = nil
        loadingState = .loaded
    }
    
}
