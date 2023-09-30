//
//  DataService.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import Foundation

let baseUrl = "openweathermap.org"

struct DataService {
    let network: Network
    
    func fetchWeather(city: String) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid="
        guard let url = URL(string: urlString) else { throw WeatherAppError.invalidURL }
        return try await network.loadData(url: url)
    }
    
    private func buildIconUrl(iconId: String) -> URL? {
        let img = "img/wn/"
        let ending = "@2x.png"
        let urlString = baseUrl + img + iconId + ending
        return URL(string: urlString)
    }
        
//https://openweathermap.org/img/wn/10d@2x.png
}


