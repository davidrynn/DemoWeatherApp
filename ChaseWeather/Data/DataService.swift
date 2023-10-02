//
//  DataService.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import Foundation

let baseUrl = "https://openweathermap.org"

protocol DataServicing {
    func fetchWeather(city: String, units: Units) async throws -> Weather
    func fetchWeather(coordinate: Coordinate, units: Units) async throws -> Weather
    func buildIconUrl(iconId: String) -> URL?
    func saveCityDefaults(_ city: String)
}

struct DataService: DataServicing {
    let network: Network
    // not great - we should be storying the keys on a server, not on the app,
    // but for the application process, keeping it here.
    private let key = "b6e4e11b74afe8f276efa54645156320"
    init(network: Network = NetworkClient()) {
        self.network = network
    }
    
    func fetchWeather(city: String, units: Units) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)&units=\(units.rawValue)"
        guard let url = URL(string: urlString) else { throw WeatherAppError.invalidURL }
        return try await network.loadData(url: url)
    }
    
    func fetchWeather(coordinate: Coordinate, units: Units) async throws -> Weather {
    }

    
    func buildIconUrl(iconId: String) -> URL? {
        let img = "/img/wn/"
        let ending = "@2x.png"
        let urlString = baseUrl + img + iconId + ending
        return URL(string: urlString)
    }
    
    func saveCityDefaults(_ city: String) {
        let key = UserDefaultsKeys.city.rawValue
        UserDefaults.standard.set(city, forKey: key)
    }
        
//https://openweathermap.org/img/wn/10d@2x.png
}

struct MockDataService: DataServicing {
    func saveCityDefaults(_ city: String) {
        return
    }
    
    func fetchWeather(city: String, units: Units) async throws -> Weather {
        let coord = Coordinate(lon: 1024.0, lat: 980.0)
        let main = Main(temp: 98, feelsLike: 99, tempMin: 0, tempMax: 120, pressure: 180, humidity: 70)
        return Weather(coord: coord, weather: [], base: "station", main: main, visibility: 1000, name: "Boise")
    }
    
    func fetchWeather(coordinate: Coordinate, units: Units) async throws -> Weather {
        let coord = Coordinate(lon: 1024.0, lat: 980.0)
        let main = Main(temp: 98, feelsLike: 99, tempMin: 0, tempMax: 120, pressure: 180, humidity: 70)
        return Weather(coord: coord, weather: [], base: "station", main: main, visibility: 1000, name: "Boise")
    }

    
    func buildIconUrl(iconId: String) -> URL? {
        return nil
    }

}
//https://api.openweathermap.org/data/2.5/weather?q=oslo&appid=b6e4e11b74afe8f276efa54645156320


