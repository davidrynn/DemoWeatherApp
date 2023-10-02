//
//  LocationService.swift
//  ChaseWeather
//
//  Created by David Rynn on 10/1/23.
//

import CoreLocation

protocol Locatable: AnyObject, ObservableObject {
    
    /// User location in `Coordinate` form
    var userLocation: Coordinate? { get }
    
    /// User has authorized location services
    var isAuthorized: Bool { get }
}

/// Wrapper for CLLocation Service
final class LocationService: NSObject, Locatable {
    
    // MARK: Property Wrapper
    @Published private(set) var userLocation: Coordinate?
    
    // MARK: Public Property
    var isAuthorized: Bool {
        locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
    
    // MARK: Private Property
    private let locationManager: CLLocationManager
    
    // MARK: Initialization
    override init() {
        // Create a CLLocationManager and assign a delegate
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // Request a user’s location once
        locationManager.requestLocation()
        if let location = locationManager.location {
            userLocation = Coordinate(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //no op for now
        return
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //no op for now
        return
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if let location = manager.location, isAuthorized {
            userLocation = Coordinate(location: location)
        }
    }
}
