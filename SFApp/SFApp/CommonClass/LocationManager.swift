//
//  LocationManager.swift
//  SFApp
//
//  Created by Anshul Mishra on 27/05/18.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit
import MapKit

protocol LocationManagerDelegate {
    func getCurrentLocation(location:CLLocation)
    func errorInLocationManager()
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = LocationManager()
    
    var delegate : LocationManagerDelegate?
    
    var locationManager = CLLocationManager()
    
    var tempViewController = UIViewController()
    
    private override init() {}
    
    func getUserLocation(viewController:UIViewController) {
        
        tempViewController = viewController
        delegate = viewController as? LocationManagerDelegate
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        if delegate != nil {
            delegate?.getCurrentLocation(location: CLLocation(latitude: locValue.latitude, longitude: locValue.longitude))
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location Manager error : \(error.localizedDescription)")
        
        if delegate != nil {
            delegate?.errorInLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            
            tempViewController.showAlert(with: APP_NAME, message: "Unable to fetch your location. Please enable access of location from the settings to get the Businesses around you.")
            
            break
        default:
            break
        }
        
    }
    
}
