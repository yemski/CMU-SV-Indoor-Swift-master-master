//
//  GPSPositioner.swift
//  CMU-SV-Indoor-Swift
//
//  Created by xxx on 12/3/14.
//  Copyright (c) 2014 CMU-SV. All rights reserved.
//

import UIKit

@objc protocol GPSPositionerDelegate {
    func didStartGPSPositioning()
    func didStopGPSPositioning()
    func didUpdateLocation(coordinate coordinate: CLLocationCoordinate2D, radius: CLLocationAccuracy)
    func didUpdateHeading(heading: CLHeading)
}

class GPSPositioner: NSObject, CLLocationManagerDelegate {
    // MARK: Properties
    
    var locManager = CLLocationManager()
    weak var parentViewController: UIViewController?
    weak var delegate: GPSPositionerDelegate?
    
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
        
        locManager.delegate = self
        startLocationAndHeadingEvents()
    }
    
    init(parentViewController: UIViewController, delegate: GPSPositionerDelegate) {
        super.init()

        self.parentViewController = parentViewController
        self.delegate = delegate
        
        locManager.delegate = self
        ///locManager.distanceFilter = 0.1
        locManager.headingFilter = 5
        startLocationAndHeadingEvents()
    }
    
    
    
    // MARK: Functional Methods
    
    func startLocationAndHeadingEvents() {
        if CLLocationManager.locationServicesEnabled() {
            locManager.requestWhenInUseAuthorization()
            locManager.startUpdatingLocation()

            if CLLocationManager.headingAvailable() {
                locManager.startUpdatingHeading()
            }
        } else {
            print("Location Service Not Enabled!!!!\n\n\n")
        }
    }
    
    
    // MARK: CLLocationManagerDelegate methods
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        print("Start GPS Positioning")
        
        delegate?.didStartGPSPositioning()
    }
    
    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        print("Stop GPS Positioning")

        delegate?.didStopGPSPositioning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
///        println("Updated Location.")
        let currentLocation = locations.last! as CLLocation
        delegate?.didUpdateLocation(coordinate: currentLocation.coordinate, radius: currentLocation.horizontalAccuracy)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {        
        delegate?.didUpdateHeading(newHeading)
    }
}
