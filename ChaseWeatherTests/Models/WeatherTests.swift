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

let testData = """
 {
   "coord": {
     "lon": -0.1257,
     "lat": 51.5085
   },
   "weather": [
     {
       "id": 803,
       "main": "Clouds",
       "description": "broken clouds",
       "icon": "04n"
     }
   ],
   "base": "stations",
   "main": {
     "temp": 289.18,
     "feels_like": 288.98,
     "temp_min": 287.65,
     "temp_max": 290.26,
     "pressure": 1020,
     "humidity": 82
   },
   "visibility": 10000,
   "wind": {
     "speed": 3.09,
     "deg": 210
   },
   "clouds": {
     "all": 75
   },
   "dt": 1696110913,
   "sys": {
     "type": 2,
     "id": 2075535,
     "country": "GB",
     "sunrise": 1696053522,
     "sunset": 1696095746
   },
   "timezone": 3600,
   "id": 2643743,
   "name": "London",
   "cod": 200
 }
""".data(using: .utf8)!
