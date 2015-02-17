//
//  ViewController.swift
//  EstimoteSwiftTest
//
//  Created by James Wilson on 2/16/15.
//  Copyright (c) 2015 jimdanger. All rights reserved.
//

/********* 

This project is where I implemented the following article: http://willd.me/posts/getting-started-with-ibeacon-a-swift-tutorial


However, I made two modifications. First, I used Estimote's SDK, so I had to replace Apple's corelocation frameword with Estimote's. (CLBeacon --> ESTBeacon) See https://github.com/Estimote/iOS-SDK#installation for more info. Second, I added a lable that changes depending on the proximity from the closest beacon. It acts up a little if you have a few beacons in the room.



*********/


import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate {

    
    @IBOutlet weak var proximityLabel: UILabel!
    
    
    // Create beacon manager instance
    let locationManager : ESTBeaconManager = ESTBeaconManager()
    
    
    // Initalize an array of beacons, by their minor numbers as keys.  This is also just RGB color values that appoximate the color of my estimote beacons. NOTE: if you grab this from github, you will have to change the minor values to match your beacons. 
    
    
    
    let colors = [
        47793: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1), // mint
        33566: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1), // blueberry
        49862: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1) // ice
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // set the current view controler (self) as the place for the delegate to send its messages to.
        
        locationManager.delegate = self

        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
                locationManager.requestWhenInUseAuthorization()
        }
        // Don't forget to edit the plist to have the text the user will see for the above request. Must be exact: "NSLocationWhenInUseUsageDescription" and it won't autocomplete.
        

        
        var beaconRegion : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Jim's Estimotes")



        
        // *** Below ***(Commented out) I just used to figure out some colors by trial and error. Note to self: find a way to do this w/ a tool.
        
            //        var x = UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1)  // blueberry
            //        var y = UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1) // ice
            //        var z = UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1) //mint
            //        self.view.backgroundColor = z
        
        locationManager.startRangingBeaconsInRegion(beaconRegion)
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // helper function to notify if a beacon is found.
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: ESTBeaconRegion!) {

        // print a feed into the console so you get an idea of what's going on. Sometimes I remove '.count' for more info. Interestingly, this gave a lot more info without Estimote's wrapper.
        println(beacons.count)
        
        // filter out all unknown beacons. Here, we're creating a new array by filtering the beacons array that the didRangeBeacons method gave us. In the filter method, we're basically letting anything through as long as its proximity value doesn't match CLProximity.Unknown.
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        if knownBeacons.count > 0 {

            
            //For the sake of simplicity here, we're going to just grab the first element in the beacons array as the closest beacon. This might not be the case so do more complicated filtering in a real application.
            let closestBeacon = knownBeacons[0] as ESTBeacon
            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
        
            switch closestBeacon.proximity{
                
                case .Far:
                    println("this is the proximityZone: Far")
                    self.proximityLabel.text = "The beacon is far away"
                
                
                case .Near:
                    println("this is the proximityZone: The beacon is near")
                    self.proximityLabel.text = "Near"
                
                case .Immediate:
                    println("this is the proximityZone: The beacon is Immediate")
                    self.proximityLabel.text = "Immediate"
                
                default:
                    println("this is the proximityZone: Default Case")
                
            }
            
        
        }else{ // if knownbeacon count is zero. (if no known beacons in range)
            self.view.backgroundColor = UIColor.whiteColor()
            self.proximityLabel.text = "Out of Range"
        }
        
    }
    
}

