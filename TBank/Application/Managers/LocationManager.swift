//
//  LocationManager.swift
//  TBank
//
//  Created by Alexander on 25.03.24.
//

import CoreLocation
import Combine

final class LocationManager: NSObject, NSCopying, CLLocationManagerDelegate {

    // MARK: - Public Properties
    static let instance = LocationManager()
    let currentLocationSubject = PassthroughSubject<[Double], Never>()
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    
    // MARK: - Init
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        requestCurrentLocation()
    }
    
    // MARK: - Methods
    private func requestCurrentLocation() {
        self.locationManager.requestLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocationSubject.send([location.coordinate.latitude, location.coordinate.longitude])
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return LocationManager.instance
    }
}
