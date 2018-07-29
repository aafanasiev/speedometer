//
//  SPDLocationManager.swift
//  speedometer
//
//  Created by Aleksandr Afanasiev on 29.07.2018.
//  Copyright © 2018 Aleksandr Afanasiev. All rights reserved.
//

import Foundation
import CoreLocation

protocol SPDLocationManagerDelegate: class {
    func locationManager(_ manager: SPDLocationManager, didUpdateLocations locations: [CLLocation])
}

protocol SPDLocationManagerAuthorizationDelegate: class {
    func locationManager(_ manager: SPDLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

protocol SPDLocationManager: class {
    
    var delegate: SPDLocationManagerDelegate? {get set}
    var authorizationDelegate: SPDLocationManagerAuthorizationDelegate? {get set}
    var authorizationStatus: CLAuthorizationStatus {get}
    
    func requestWhenInUseAuthorization()
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
}

class SPDLocationManagerProxy: NSObject {
    
    weak var delegate: SPDLocationManagerDelegate?
    weak var authorizationDelegate: SPDLocationManagerAuthorizationDelegate?
    
    let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
}

extension SPDLocationManagerProxy: SPDLocationManager {
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
}

extension CLLocationManager: SPDLocationManager {
    
    var delegate: SPDLocationManagerDelegate? {
        get {
            <#code#>
        }
        set {
            <#code#>
        }
    }
    
    var authorizationDelegate: SPDLocationManagerAuthorizationDelegate? {
        get {
            <#code#>
        }
        set {
            <#code#>
        }
    }
    
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }

}

extension SPDLocationManagerProxy: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationManager(self, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationDelegate?.locationManager(self, didChangeAuthorization: status)
    }
    
    
}
