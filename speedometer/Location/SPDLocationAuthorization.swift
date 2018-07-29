//
//  SPDLocationAuthorization.swift
//  speedometer
//
//  Created by Aleksandr Afanasiev on 29.07.2018.
//  Copyright © 2018 Aleksandr Afanasiev. All rights reserved.
//

import Foundation
import CoreLocation

extension NSNotification.Name {
    static let SPDLocationAuthorized = NSNotification.Name("NSNotification.Name.SPDLocationAuthorized")
}

protocol SPDLocationAuthorizationDelegate: class {
    
    func authorizationDenied(for locationAuthorization: SPDLocationAuthorization)
}

protocol SPDLocationAuthorization: class {
    
    var delegate: SPDLocationAuthorizationDelegate? {get set}
    
    func checkAuthorization()
    
}

class SPDDegfaultLocationAuthorization {
    
    weak var delegate: SPDLocationAuthorizationDelegate?
    let locationManager: SPDLocationManager
    
    init(locationManager: SPDLocationManager) {
        self.locationManager = locationManager
        
        locationManager.authorizationDelegate = self
    }
    
}

extension SPDDegfaultLocationAuthorization: SPDLocationManagerAuthorizationDelegate {
    
    func locationManager(_ manager: SPDLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            NotificationCenter.default.post(name: .SPDLocationAuthorized, object: self)
        case .denied, .restricted:
            delegate?.authorizationDenied(for: self)
        default:
            break
        }
        
    }
    
}

extension SPDDegfaultLocationAuthorization: SPDLocationAuthorization {
    
    func checkAuthorization() {
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
    }
    
}
