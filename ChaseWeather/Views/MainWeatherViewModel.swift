//
//  MainWeatherViewModel.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import Combine
import CoreLocation
import SwiftUI

final class MainWeatherViewModel: ObservableObject {
    
    // MARK: Property wrappers
    @Published var loadingState: LoadingState = .loaded
    @Published var city: String
    @Published var temperature: String = "0.0"
    @Published var iconURL: URL?
    @Published var units: Units = .imperial
    @Published var errorMessage: String?
    @Published var humidity: String?
    
    // MARK: Private properties
    private var dataService: DataServicing
    private var locationService: LocationService
    private var cancellables = Set<AnyCancellable>()
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    // MARK: Initialization
    init(dataService: DataServicing, locationService: LocationService) {
        self.dataService = dataService
        self.locationService = locationService
        self.city = UserDefaults.standard.string(forKey: "city") ?? ""
        if let location = locationService.userLocation {
                    Task {
                        await self.getWeatherByUserLocation(coordinate: location)
                    }
        }
        cancellables = [locationService.$userLocation
            .sink() {
                print ("Location lat now: \(String(describing: $0?.lat))")
                if let location = $0 {
                                        Task {
                                            await self.getWeatherByUserLocation(coordinate: location)
                                        }
                }
            }]
        if locationService.userLocation != nil && !city.isEmpty {
            Task {
                await getWeatherByCity()
            }
        }
    }
    
    // MARK: Public functions
    @MainActor
    func getWeatherByCity() async {
        loadingState = .loading
            do {
                let weather = try await dataService.fetchWeather(city: city, units: units)
                if let temp: String = numberFormatter.string(from: NSNumber(floatLiteral: weather.main.temp)) {
                    temperature = temp
                } else {
                    temperature = "\(weather.main.temp)"
                }
                humidity = String(weather.main.humidity)
                loadingState = .loaded
                dataService.saveCityDefaults(city)
                if let weatherIcon = weather.weather.first?.icon {
                    iconURL = dataService.buildIconUrl(iconId: weatherIcon)
                } else {
                    iconURL = nil
                }
            } catch {
                loadingState = .error
                if let error = error as? WeatherAppError {
                    errorMessage = error.message
                }
            }
    }
    
    @MainActor
    func getWeatherByUserLocation(coordinate: Coordinate) async {
        loadingState = .loading
            do {
                 let cities = try await dataService.fetchCities(coordinate: coordinate)
                     guard let city = cities.first else {
                    throw WeatherAppError.parsing
                }
                self.city = city.name
                await self.getWeatherByCity()
            } catch {
                loadingState = .error
                if let error = error as? WeatherAppError {
                    errorMessage = error.message
                }
            }
    }
    
    func reset() {
        city = ""
        temperature = "0.0"
        iconURL = nil
        loadingState = .loaded
    }
    
}
