//
//  searchModalViewController.swift
//  CMU-SV-Indoor-Swift
//
//  Created by Piers Yem on 11/11/15.
//  Copyright © 2015 CMU-SV. All rights reserved.
//

import UIKit


class searchModalViewController: UIViewController {

    var markerID : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
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

    @IBAction func backtomapBtn(sender: AnyObject) {
        markerfromModal = "A"
        performSegueWithIdentifier("backtomapSegue", sender: sender)
    }
    
    @IBAction func backtomapBtn2(sender: AnyObject) {
        markerfromModal = "B"
        performSegueWithIdentifier("backtomapSegue", sender: sender)
    }
    
    @IBAction func backtomapBtn3(sender: AnyObject) {
        markerfromModal = "C"
        performSegueWithIdentifier("backtomapSegue", sender: sender)

    }
  }
