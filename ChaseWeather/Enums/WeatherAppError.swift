//
//  WeatherAppError.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

enum WeatherAppError: Error {
    case network, unexpected(Error), invalidURL, parsing, invalidCity
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid url, contact customer support."
        case .parsing:
            return "Parsing error, invalid data, contact customer support."
        case .network:
            return "Network error, please try again."
        case .invalidCity:
            return "Invalid city name."
        case .unexpected(let error):
            return "Unexpected error: \(error.localizedDescription) Contact customer support."
        }
    }
}

extension WeatherAppError: Equatable {
    static func == (lhs: WeatherAppError, rhs: WeatherAppError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL), (.parsing, .parsing), (.network, .network), (.invalidCity, .invalidCity) :
            return true
        case (.unexpected(error: let err1), .unexpected(error: let err2)):
            return err1.localizedDescription == err2.localizedDescription
        default:
            return false
        }
    }
}
