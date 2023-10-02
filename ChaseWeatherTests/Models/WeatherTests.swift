//
//  WeatherTests.swift
//  ChaseWeatherTests
//
//  Created by David Rynn on 9/30/23.
//

@testable import ChaseWeather
import XCTest

final class WeatherTests: XCTestCase {

    var decoder = JSONDecoder()
    
    func testModel_doesDecode() {
        // Given
        let jsonData = testData
        
        //When
        do {
            let weather = try decoder.decode(Weather.self, from: jsonData)
            
            // Then
            XCTAssertEqual(weather.base, "stations")

        } catch {
            guard let error = error as? DecodingError else {
                XCTFail("not a decoding error")
                return
            }
            // Use these different errors to debug decoding
            switch error {
            case .typeMismatch(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .valueNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .keyNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .dataCorrupted(let key):
                print("error \(key), and ERROR: \(error.localizedDescription)")
            default:
                print("ERROR: \(error.localizedDescription)")
            }
            XCTFail("Unable to decode")
        }
    }

}
