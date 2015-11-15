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

class LocationFinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var locations: [PFObject]!
    
    // setting up for search
    
    var data: [String]!
    var filteredData: [String]!
    var searchController: UISearchController!
//    var searchBar: UISearchBar!

    // end search setup

    
    
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
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //START SEARCH STUFF - github.com/codepath/ios_guides/wiki/Search-Bar-Guide
        data = ["Conference Room A", "Conference Room B", "Colbie Callait", "Training Room", "Cafeteria", "Observation Room"]
        filteredData = data
        
        searchBar = UISearchBar()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        //END SEARCH STUFF

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
        print("locations.count = \(locations.count)")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("LocationResultsCell") as! LocationResultsCell
        
        var location = locations[indexPath.row]
        
        cell.nameLabel.text = location["Room_Name"] as? String
        
        let building = location["Building"] as? String
        
        if building == "SB850C" {
            cell.buildingsAddressLabel.text = "850 Cherry Ave., San Bruno"
        } else if building == "SB860E" {
            cell.buildingsAddressLabel.text = "860 Elm Ave., San Bruno"
        } else if building == "SV850C" {
            cell.buildingsAddressLabel.text = "850 California Ave., Sunnyvale"
        } else if building == "SV850C" {
            cell.buildingsAddressLabel.text = "840 California Ave., Sunnyvale"
        }
        
        let onFloor = location["Floor"] as? Int
        if onFloor != nil {
            cell.floorNumberLabel.text = "Floor: \(location["Floor"])"
        } else if onFloor == nil {
            cell.floorNumberLabel.text = "Floor unknown"
            cell.floorNumberLabel.textColor = UIColor.lightGrayColor()
        }
               
        let isRoom = location["isRoom"] as! Bool
        let isAvailable = location["Available_now"] as? Int
        let hasCapacity = location["Capacity"] as? Int
        
        // Available_now: 1 = available, 0 = not available, -1 = not the kind of place you book (restroom, cafeteria, etc)
        
        if isRoom == true {
            cell.locationTypeImageView.image = UIImage(named: "room icon")
            
            if isAvailable != nil && isAvailable == 1 {
                cell.roomAvailabilityLabel.text = "Available Now"
                cell.roomAvailabilityLabel.textColor = UIColor.greenColor()
            } else if isAvailable != nil && isAvailable == 0 {
                cell.roomAvailabilityLabel.text = "Not Available"
                cell.roomAvailabilityLabel.textColor = UIColor.redColor()
            } else if isAvailable != nil && isAvailable == -1 {
                cell.roomAvailabilityLabel.alpha = 0
            } else {
                cell.roomAvailabilityLabel.text = "Availability Unknown"
                cell.roomAvailabilityLabel.textColor = UIColor.grayColor()
            }
            
            cell.roomCapacityLabel.text = "Capacity: \(location["Capacity"])"
//            cell.roomAvailabilityLabel.alpha = 1
//            cell.roomCapacityLabel.alpha = 1
            
        } else {  //if isRoom is false, then we're assuming it's a person. Could there be other types to capture? would we want to return the person's title, if available? any other data for people?
            cell.locationTypeImageView.image = UIImage(named: "person icon")
            if isAvailable == 0 {
                cell.roomAvailabilityLabel.text = "In a meeting"
                cell.roomAvailabilityLabel.textColor = UIColor.redColor()
            } else {
                cell.roomAvailabilityLabel.alpha = 0
            }
            cell.roomCapacityLabel.alpha = 0
        }
        
        
        return cell
    }
//FROM MATT
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
////        let location = locations[indexPath.row]
        let destinationViewController = segue.destinationViewController as! TestViewController
        destinationViewController.locationFromResults = locations[indexPath.row]
//
//        destinationViewController.locationFromResults.opacity = 1
//
//        destinationViewController.markerFromResults.position = (location["Long_Lat"] as? CLLocationCoordinate2D!)!
//        
//        destinationViewController.markerFromResults.title = location["Room Name"] as? String!
//        destinationViewController.markerFromResults.snippet = location["Capacity"] as? String!
       
    }

    //END FROM MATT

    //FROM TIM
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
////        Get the new view controller using segue.destinationViewController.
////        Pass the selected object to the new view controller.
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPathForCell(cell)!
//        
//        let yourViewController = segue.destinationViewController as! YourDestinationViewController
//        
//        yourViewController.variableName = rooms[indexPath.row]
//    }
//END FROM TIM
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
