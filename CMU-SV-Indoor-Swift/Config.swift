//
//  Config.swift
//  CMU-SV-Indoor-Swift
//
//  Created by xxx on 12/2/14.
//  Copyright (c) 2014 CMU-SV. All rights reserved.
//

import Foundation

// MARK: IndoorAtlas API Keys and Secrets
let INDOORATLAS_API_Key = ""
let INDOORATLAS_SECRRET = ""

//FLOORPLANID for 850 Cherry
let BSB_1F_ID = "929b24c3-6902-435c-a505-d6bc0448c22a"
let B23_1F_ID = "6ba0ce2b-9a57-4d06-9dcf-c1a443c07376"
let B23_2F_ID = "7e5f7360-21be-4076-90d2-4361d2612457"



// MARK: Google Map API Key
let GMS_API_KEY         = ""



// MARK: Constants

let INIT_CAM_LAT            = 37.6270974//37.6273511
let INIT_CAM_LON            = -122.4244718//-122.42468757
let INIT_CAM_ZOOM: Float   = 18.8

let BSB_LAT             = 37.62711860656018//37.6274901
let BSB_LON             = -122.42447912693024//-122.42467850

let BSB_SCALE: CGFloat  = 20.32//20.01
let BSB_BEARING         = 243.99
let BSB_RANGE           = 65.0

let B23_LAT             = 37.410413
let B23_LON             = -122.059732
let B23_SCALE: CGFloat  = 20.85
let B23_BEARING         = 157.6
let B23_RANGE           = 40.0

let B23_1F = "B23_1F"
let B23_2F = "B23_2F"
let BSB_1F = "BSB_1F"

let BSB_COORD = CLLocationCoordinate2DMake(BSB_LAT,  BSB_LON)
let B23_COORD = CLLocationCoordinate2DMake(B23_LAT,  B23_LON)

let BUILDINGS_ARRAY = [
    Building.BuildingSB: BuildingInfo(coordinate: BSB_COORD, range: BSB_RANGE, distance: 0),
    Building.Building23: BuildingInfo(coordinate: B23_COORD, range: B23_RANGE, distance: 0)
]

let redColor        = UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0)
let blueColor       = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
let greyColor       = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
let darkGreyColor   = UIColor(red: 0.375, green:0.375, blue: 0.375, alpha: 1.0)
