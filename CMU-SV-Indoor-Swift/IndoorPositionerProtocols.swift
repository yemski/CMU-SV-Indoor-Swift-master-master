//
//  IndoorPositionerProtocols.swift
//  CMU-SV-Indoor-Swift
//
//  Created by xxx on 12/7/14.
//  Copyright (c) 2014 CMU-SV. All rights reserved.
//

protocol IndoorPositioner {
    func stopPositioning()
    func startPositioning(building building: Building, floor: Floor)
}

@objc protocol IndoorPositionerDelegate {
    func indoorPositionerStateChanged(state: String)
    func indoorPositioningStopped()
    func indoorPositionerFailed()
    func indoorPositionChanged(coordinate: CLLocationCoordinate2D, radius: CLLocationAccuracy)
}