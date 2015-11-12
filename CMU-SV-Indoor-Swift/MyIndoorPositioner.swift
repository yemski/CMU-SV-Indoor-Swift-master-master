//
//  MyIndoorPositioner.swift
//  CMU-SV-Indoor-Swift
//
//  Created by xxx on 12/3/14.
//  Copyright (c) 2014 CMU-SV. All rights reserved.
//

import UIKit

let indoorPositionerStates = [
    "Stopped",
    "Connecting",
    "Reconnecting",
    "Connected",
    "Loading",
    "Ready",
    "WaitingForFix",
    "Positioning",
    "Buffering",
    "HeavyBuffering"
]



class MyIndoorPositioner: NSObject, IndoorPositioner, IndoorAtlasPositionerDelegate {
    // MARK: Properties
    
    var idaPositioner = IndoorAtlasPositioner()
    var floorplan = IndoorAtlasFloorplan()
    var positionAvailable = false
    
    weak var parentViewController: UIViewController?
    weak var delegate: IndoorPositionerDelegate?
    
    var indoorPositioningTurnedOn = false
    
    
    // MARK: Initializer(s)
    
    override init() {
        super.init()
        
        // Print IndoorAltas API version
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print("IndoorAtlas version: \(IndoorAtlas.versionString())")
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")
        
        authenticateAndFetchFloorplan()
    }
    
    
    
    // MARK: IndoorPositioner Methods
    
    func stopPositioning() {
        indoorPositioningTurnedOn = false
        idaPositioner.stop()
    }
    
    func startPositioning(building building: Building, floor: Floor) {
        indoorPositioningTurnedOn = true
        
        switch (building, floor) {
        case (.BuildingSB, .Floor1):
            fetchFloorplanWithId(BSB_1F_ID)
        case (.Building23, .Floor1):
            fetchFloorplanWithId(B23_1F_ID)
        case (.Building23, .Floor2):
            fetchFloorplanWithId(B23_2F_ID)
        default:
            failGracefully("Invalid building-floor combination")
        }
    }
    
    
    
    // MARK: IndoorAtlas API Methods
    
    private func authenticateAndFetchFloorplan() {
        // Set IndoorAtlas API Key and Secret
        IndoorAtlas.setApiKey(INDOORATLAS_API_Key, andSecret: INDOORATLAS_SECRRET)
    }
    
    private func fetchFloorplanWithId(floorplanId: String) {
        let alert = UIAlertController(title: nil, message: "Fetching flooplan...", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        okButton.enabled = false
        
        alert.addAction(okButton)

        self.parentViewController!.presentViewController(alert, animated: true, completion: nil)
        
        IndoorAtlas.fetchFloorplanWithId(floorplanId, completion: { [unowned self] (floorplan: IndoorAtlasFloorplan!, error: NSError!) -> Void in
            
            if error != nil {
                print("Opps, there was error during floorplan fetch: \(error!)\n\n\n")
                
                alert.message = "Error: \(error!.localizedDescription)"
                
                okButton.enabled = true

                self.delegate?.indoorPositionerFailed()
                
                return;
            }
            
            alert.dismissViewControllerAnimated(false, completion: nil)

            print("Fetched floorplan with ID: \(floorplanId)")
            
            self.floorplan = floorplan
            self.calibrateAndStartPositioningWithFloorplan(floorplan)
        })


        /*
        Alternatiely, consider use the following method calls:
        
        IndoorAtlas.fetchFloorplanImage(floorplan: IndoorAtlasFloorplan!, completion: { (NSData!, String!, NSError!) -> Void in
            code
        })
        IndoorAtlas.fetchFloorplanImage(floorplan: IndoorAtlasFloorplan!, completion: { (NSData!, String!, NSError!) -> Void in
            code
        }, progress: { (Float) -> Void in
            code
        })
        */
    }
    
    func calibrateAndStartPositioningWithFloorplan(floorplan: IndoorAtlasFloorplan) {
        
        
        // [IndoorAtlasCalibrator calibrationStatus] returns the status of current calibration.
        // Check the documentation of calibrationStatus method for more details.
        if IndoorAtlas.calibrator().calibrationStatus != IndoorAtlasCalibrationStatus.NoCalibration {
            startPositioningWithFloorplan(floorplan)
            return
        }
        
        let alertViewController = UIAlertController(title: nil, message: "Device needs to be calibrated. Rotate device around after pressing 'Calibrate'", preferredStyle: UIAlertControllerStyle.Alert)
        
        let calibrateButton = UIAlertAction(title: "Calibrate", style: UIAlertActionStyle.Default, handler: { [unowned self] (UIAlertAction) in
            
            let calibrationProgressAlert = UIAlertController(title: "0%", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            self.parentViewController!.presentViewController(calibrationProgressAlert, animated: true, completion: nil)
            
            IndoorAtlas.calibrator().calibrateUsingBackgroundCalibrator({ (error: NSError!) -> Void in
                
                if error != nil {
                    print("Oops, there was error during calibration: \(error!)")
                    self.swift_performSelector("calibrateAndStartPositioningWithFloorplan:", withObject: floorplan, afterDelay: 0)
                    return
                }
                
                print("Calibration Done")
                calibrationProgressAlert.dismissViewControllerAnimated(false, completion: nil)
                shakeDevice()
                
                self.startPositioningWithFloorplan(floorplan)
                
            }, progress: { (progress: Float) -> Void in
                
                print("Calibration: \(progress)")
                calibrationProgressAlert.title = NSString(format:"Calibration: %.1f%%", progress * 100) as String
                
            })
        })
        
        alertViewController.addAction(calibrateButton)
        
        self.parentViewController!.presentViewController(alertViewController, animated: true, completion: nil)
        
        shakeDevice()

/*
        var alert = IDAAlertView(title: "", message: "Device needs to be calibrated. Move device around naturally after pressing 'Calibrate'", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Calibrates")
        
        alert.addBlock({ [unowned self] in
            var progressAlert = UIAlertView(title: "0%", message: "", delegate: nil, cancelButtonTitle: nil)
        
            progressAlert.show()
    
            IndoorAtlas.calibrator().calibrateUsingBackgroundCalibrator({ (error: NSError!) -> Void in
                progressAlert.dismissWithClickedButtonIndex(progressAlert.cancelButtonIndex, animated: false)
                
                if error != nil {
                    println("Oops, there was error during calibration: \(error!)")
                    self.swift_performSelector("calibrateAndStartPositioningWithFloorplan:", withObject: floorplan, afterDelay: 0)
                    return
                }
                
                AudioServicesPlaySystemSound(0x00000FFF);
                self.startPositioningWithFloorplan(floorplan)
            }, progress: { (progress: Float) -> Void in
                println("Calibration: \(progress)")
                progressAlert.title = "\(progress * 100)%"
            })
        }, forButtonIndex: alert.firstOtherButtonIndex)
        
        alert.show()
*/
    }
    
    private func startPositioningWithFloorplan(floorplan: IndoorAtlasFloorplan) {
        idaPositioner.stop()
/*
        let alertViewController = UIAlertController(title: nil, message: "Press 'Start' to start positioning", preferredStyle: UIAlertControllerStyle.Alert)
        
        let startButton = UIAlertAction(title: "Start", style: UIAlertActionStyle.Default, handler: { [unowned self] (UIAlertAction) in

            self.idaPositioner = IndoorAtlas.positionerForFloorplan(floorplan)
            self.idaPositioner.delegate = self
            self.idaPositioner.start()
        })
        
        alertViewController.addAction(startButton)
        
        self.parentViewController?.presentViewController(alertViewController, animated: false, completion: nil)
*/
        self.idaPositioner = IndoorAtlas.positionerForFloorplan(floorplan)
        self.idaPositioner.delegate = self
        self.idaPositioner.start()
}
    
    
    
    // MARK: IndoorAtlasPositionerDelegate Methods
    
    func indoorAtlasPositioner(positioner: IndoorAtlasPositioner!, stateChanged state: IndoorAtlasPositionerState!) {
        delegate?.indoorPositionerStateChanged(indoorPositionerStates[state.state.rawValue])
        
        if state.error != nil {
            print("State changed to: \(indoorPositionerStates[state.state.rawValue]) (\(state.state.rawValue)) because of error \(state.error)")
            
            let errorAlert = UIAlertController(title: nil, message: "IDP state changed to '\(indoorPositionerStates[state.state.rawValue])' because of error: \n\(state.error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            errorAlert.addAction(okButton)
            
            self.parentViewController?.presentViewController(errorAlert, animated: true, completion: nil)
            
            self.delegate?.indoorPositionerFailed()
        } else {
            print("State changed to: \(indoorPositionerStates[state.state.rawValue]) (\(state.state.rawValue))")
        }
        
        if (state.state == IndoorAtlasPositioningState.Stopped
            || state.state == IndoorAtlasPositioningState.HeavyBuffering)
            && state.error == nil
        {
            positionAvailable = false
            delegate?.indoorPositioningStopped()
            
            if indoorPositioningTurnedOn {
                if positioner.floorplan == self.floorplan {
                    // Start again from calibration if positioning stopped and floor plan was not changed
                    self.swift_performSelector("calibrateAndStartPositioningWithFloorplan:", withObject: positioner.floorplan, afterDelay: 0.0)
                }
            }
        
            UIApplication.sharedApplication().idleTimerDisabled = false
        } else {
            // It is good idea to disable idle timer when positioning.
            // This prevents the screen from dimming.
            UIApplication.sharedApplication().idleTimerDisabled = true
        }
    }
    
    func indoorAtlasPositioner(positioner: IndoorAtlasPositioner!, positionChanged position: IndoorAtlasPosition!) {
        // You may also get metric and coordinate position from the packet.
        // The accuracy of coordinate position depends on the placement of floor plan image.
        print("Position changed to pixel point: (\(position.pixelPoint.x), \(position.pixelPoint.y))")

        self.delegate?.indoorPositionChanged(CLLocationCoordinate2DMake(position.coordinate.latitude, position.coordinate.longitude),
            radius: position.radius
        )
        
        positionAvailable = true
    }
}
