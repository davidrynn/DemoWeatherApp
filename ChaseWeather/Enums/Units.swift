//
//  Units.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

enum Units: String, CaseIterable, Identifiable {
    case standard = "standard"
    case metric = "metric"
    case imperial = "imperial"
    
    var id: String {
        return self.rawValue
    }
}
