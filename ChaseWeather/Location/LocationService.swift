//
//  LocationService.swift
//  ChaseWeather
//
//  Created by David Rynn on 10/1/23.
//

import CoreLocation

protocol Locatable: AnyObject {
    var userLocation: Coordinate? { get }
//    let locationManager: CLLocationManager
}

/// Wrapper for CLLocation Service
class LocationService: NSObject, Locatable {
    
    private let locationManager: CLLocationManager
    var userLocation: Coordinate?
    
    override init() {
        // Create a CLLocationManager and assign a delegate
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // Request a user’s location once
        locationManager.requestLocation()
    }
}
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if let location = manager.location, manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            userLocation = Coordinate(location: location)
        }
    }
}

class MockLocationService: Locatable {
    
}
