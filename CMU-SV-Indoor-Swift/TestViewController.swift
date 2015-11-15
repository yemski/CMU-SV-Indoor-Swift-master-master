//
//  TestViewController.swift
//  CMU-SV-Indoor-Swift
//
//  Created by Jon Baron on 11/15/15.
//  Copyright © 2015 CMU-SV. All rights reserved.
//

import UIKit
import Parse
import Bolts

class TestViewController: UIViewController {

    var locationFromResults: PFObject!
    var markerFromResults: GMSMarker!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Loaded Test View Controller")
        print("Room: \(locationFromResults["Room_Name"])")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
