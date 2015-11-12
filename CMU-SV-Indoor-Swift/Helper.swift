//
//  Helper.swift
//  CMU-SV-Indoor-Swift
//
//  Created by xxx on 12/6/14.
//  Copyright (c) 2014 CMU-SV. All rights reserved.
//

import UIKit
import AudioToolbox



// MARK: Helper Types

public enum Building: NSString {
    case None = "None"
    case BuildingSB = "BuildingSB"
    case Building23 = "Building23"
}

public enum Floor {
    case None
    case Floor1
    case Floor2
}

public class BuildingInfo {
    let coordinate: CLLocationCoordinate2D
    let range: CLLocationDistance
    var distance: CLLocationDistance

    init(coordinate: CLLocationCoordinate2D, range: CLLocationDistance, distance: CLLocationDistance) {
        self.coordinate = coordinate
        self.range = range
        self.distance = distance
    }
}

extension CLLocationCoordinate2D: Hashable {
    public var hashValue : Int {
        get {
            return "\(self.latitude),\(self.longitude)".hashValue
        }
    }
}



// MARK: Helper Functions

public func shakeDevice() {
    AudioServicesPlaySystemSound(0x00000FFF);
}

public func getTopViewController() -> UIViewController {
    var topViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
    
    while topViewController.presentedViewController != nil {
        topViewController = topViewController.presentedViewController!
    }
    
    return topViewController
}

public func failGracefully(reason: String) {
    let failAlert = UIAlertController(title: "Applicaiton failed.", message: "Due to: \"\(reason)\"", preferredStyle: UIAlertControllerStyle.Alert)
    
    let terminateButton = UIAlertAction(title: "Terminate", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
        exit(EXIT_FAILURE)
    })
    
    failAlert.addAction(terminateButton)
    
    getTopViewController().presentViewController(failAlert, animated: false, completion: nil)
}

public func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
    return (left.latitude == right.latitude) && (left.longitude == right.longitude)
}

public func != (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
    return !(left == right)
}

public func + (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(left.latitude + right.latitude, left.longitude + right.longitude)
}

public func distanceInMetersBetween(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> CLLocationDistance {
    let earthRadius = 6371_010.0  // Earth radius in meters
    
    let DEG_TO_RAD = 0.017453292519943295769236907684886;
    let EARTH_RADIUS_IN_METERS = 6372797.560856;
    
    let latitudeArc  = (left.latitude - right.latitude) * DEG_TO_RAD;
    let longitudeArc = (left.longitude - right.longitude) * DEG_TO_RAD;
    let latitudeH = sin(latitudeArc * 0.5);
    let lontitudeH = sin(longitudeArc * 0.5);
    let tmp = cos(left.latitude * DEG_TO_RAD) * cos(right.latitude * DEG_TO_RAD);
    return EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH * latitudeH + tmp * lontitudeH * lontitudeH));
    
    //return sqrt( pow( (left.latitude - right.latitude), 2) + pow( (left.longitude - right.longitude), 2) ) * earthRadius / 360.0
}

public func exitWithAlert() {
    exit(EXIT_FAILURE)
}