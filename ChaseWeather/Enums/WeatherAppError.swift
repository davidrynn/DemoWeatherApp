//
//  WeatherAppError.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

enum WeatherAppError: Error {
    case network, unexpected(Error), invalidURL, parsing
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid url, contact customer support."
        case .parsing:
            return "Parsing error, invalid data, contact customer support."
        case .network:
            return "Network error, please try again."
        case .unexpected(let error):
            return "Unexpected error: \(error.localizedDescription) Contact customer support."
        }
    }
}
