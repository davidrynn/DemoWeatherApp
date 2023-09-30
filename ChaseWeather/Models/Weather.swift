//
//  WeatherIcon.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import Foundation

struct Weather: Decodable {
    let coord: Coordinate
    let weather: [WeatherIcon]
    let base: String
    let main: Main
    let visibility: Int
    let name: String
    
}

struct WeatherIcon: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Coordinate: Decodable {
    let lon: CGFloat
    let lat: CGFloat
}

struct Main: Decodable {
    let temp: CGFloat
    let feelsLike: CGFloat
    let tempMin: CGFloat
    let tempMax: CGFloat
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
    
}

//https://openweathermap.org/img/wn/10d@2x.png

/*
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
 */
