//
//  DataService.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import Foundation

let baseUrl = "https://openweathermap.org"

protocol DataServicing {
    /// Fetches the Weather data from the API using `async` and `throw`
    /// - Parameters:
    ///   - city: String of city name
    ///   - units: Type of units to use for temperature
    /// - Returns: Weather model
    func fetchWeather(city: String, units: Units) async throws -> Weather

    /// Fetches a US city based on the latitude and longitude coordinates of the user
    /// - Parameter coordinate: Simple `Coordinate` model
    /// - Returns: Array of `City` models corresponding to cities that could be at that coordinate
    /// @Discussion: It seems odd to have an array of cities based on a single coordinate, but this is the
    /// from the response of the API. Maybe it's because some cities don't have clear boundries and they can
    /// overlap.
    func fetchCities(coordinate: Coordinate) async throws -> [City]

    /// Builds the URL used for getting the image icon
    /// - Parameter iconId: An id from the `WeatherIcon model`
    /// - Returns: An optional URL object
    func buildIconUrl(iconId: String) -> URL?

    /// Saves the city name string to defaults for use when first launching the app
    /// - Parameter city: <#city description#>
    func saveCityDefaults(_ city: String)
}

struct DataService: DataServicing {
    let network: Network
    init(network: Network = NetworkClient()) {
        self.network = network
    }

    func fetchWeather(city: String, units: Units) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)&units=\(units.rawValue)"
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            throw WeatherAppError.invalidCity
        }
        guard let url = URL(string: encoded) else { throw WeatherAppError.invalidURL }
        return try await network.loadData(url: url)
    }

    func fetchCities(coordinate: Coordinate) async throws -> [City] {
        //TODO: With more time, if there are more than one city fetched, give user the option to pick one
        let urlString = "http://api.openweathermap.org/geo/1.0/reverse?lat=\(coordinate.lat)&lon=\(coordinate.lon)&limit=5&appid=\(key)"
        guard let url = URL(string: urlString) else { throw WeatherAppError.invalidURL }
        return try await network.loadData(url: url)
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

    func fetchCities(coordinate: Coordinate) async throws -> [City] {
        return [City(name: "Poughkeepsie")]
    }

    func buildIconUrl(iconId: String) -> URL? {
        return nil
    }

}
