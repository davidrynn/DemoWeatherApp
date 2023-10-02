//
//  DataServiceTests.swift
//  ChaseWeatherTests
//
//  Created by David Rynn on 10/2/23.
//

@testable import ChaseWeather
import XCTest

final class DataServiceTests: XCTestCase {
    
    func test_shouldLoad() async throws {
        // Given
        let client = NetworkClient(downloader: TestDownloader())
        let sut = DataService(network: client)
        
        // When
        let weather = try await sut.fetchWeather(city: "Boise", units: .imperial)
        
        // Then
        let weatherIconArray = [
            WeatherIcon(id: 803, main: "Clouds", description: "broken clouds", icon: "04n")
        ]
        let main = Main(temp: 289.18, feelsLike: 288.98, tempMin: 287.65, tempMax: 290.26, pressure: 1020, humidity: 82)
        let expectedResult = Weather(coord: Coordinate(lon: -0.1257, lat: 51.5085), weather: weatherIconArray, base: "stations", main: main, visibility: 10000, name: "London")
        XCTAssertEqual(weather, expectedResult)
    }
    
    func test_shouldNotLoad() async {
        // Given
        let downloader = TestDownloader()
        downloader.shouldThrowNetworkError = true
        let client = NetworkClient(downloader: downloader)
        let sut = DataService(network: client)
        
        // When
        do {
            let _ = try await sut.fetchWeather(city: "NoWhereLand", units: .imperial)
        } catch {
            if let error = error as? WeatherAppError {
                XCTAssertEqual(error, .network)
                return
            }
        }
        XCTFail("network call completed without throwing when it should have")
    }

}
