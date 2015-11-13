//
//  LocationFinderViewController.swift
//  CMU-SV-Indoor-Swift
//
//  Created by Jon Baron on 11/12/15.
//  Copyright © 2015 CMU-SV. All rights reserved.
//

import UIKit
import Parse
import Bolts

class LocationFinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var locations: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locations = []
        
        var query = PFQuery(className: "rooms")
        query.orderByAscending("Room_Name")
        query.findObjectsInBackgroundWithBlock { (locations: [PFObject]?, error: NSError?) -> Void in
            print("got the locations")
            print(locations)
            self.locations = locations
            self.tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("LocationResultsCell") as! LocationResultsCell
        
        var location = locations[indexPath.row]
        
        cell.nameLabel.text = location["Room_Name"] as? String
        
        if location["Building"] == "SB850C" {
            cell.buildingsAddressLabel.text = "850 Cherry Ave., San Bruno"
        } else if location["Building"] == "SB860E" {
            cell.buildingsAddressLabel.text = "860 Elm Ave., San Bruno"
        } else if location["Building"] == "SV850C" {
            cell.buildingsAddressLabel.text = "850 California Ave., Sunnyvale"
        } else if location["Building"] == "SV850C" {
            cell.buildingsAddressLabel.text = "840 California Ave., Sunnyvale"
        }
        
        return cell
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
