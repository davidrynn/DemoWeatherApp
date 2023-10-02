//
//  TestHttpsDownloader.swift
//  ChaseWeather
//
//  Created by David Rynn on 10/2/23.
//

import Foundation

/// Network downloader used for unit tests and previews
class TestDownloader: HTTPDataDownloader {
    // data property can be changed to suit needs
    var data: Data = testData
    
    // throws a network error instead of returning data
    var shouldThrowNetworkError = false
    
    func httpData(from url: URL) async throws -> Data {
        if shouldThrowNetworkError {
            throw WeatherAppError.network
        }
        try await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...500_000_000))
        return data
    }
}
