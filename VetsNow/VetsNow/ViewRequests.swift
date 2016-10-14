//
//  ViewRequests.swift
//  VetsNow
//
//  Created by Admin on 10/14/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Parse



class ViewRequests : UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var requestMap: MKMapView!
    
    var requestedLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    
    var username:String = ""
    
    @IBAction func pickUpPetOwner(_ sender: AnyObject) {
        
        let q = PFQuery(className: "riderRequest")
        
        q.whereKey("username", contains: username)
        
        q.findObjectsInBackground { (objects, error) in
            
            for obj in objects! {
                
                obj["driverResponded"] = "Hello"
                
                obj.saveInBackground { (true, error) in
                    
                    print("K")
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        let region = MKCoordinateRegion(center: requestedLocation, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        
        self.requestMap.setRegion(region, animated: true)
        
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = requestedLocation
        objectAnnotation.title = username
        self.requestMap.addAnnotation(objectAnnotation)
        
        
    }
    
}
