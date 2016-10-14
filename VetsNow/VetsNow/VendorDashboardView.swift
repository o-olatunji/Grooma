//
//  VendorDashboardView.swift
//  VetsNow
//
//  Created by Admin on 10/13/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MapKit

class VendorDashboardView : UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    let main = OperationQueue.main
    @IBOutlet weak var riderRequestTable: UITableView!
    
    var usernames:[String] = []
    var locations:[CLLocationCoordinate2D] = []
    var distances:[CLLocationDistance] = []
    
    var locationManager:CLLocationManager!
    
    var lat :CLLocationDegrees = 0
    var long :CLLocationDegrees = 0
    
    override func viewDidLoad() {
        
        riderRequestTable.delegate = self
        riderRequestTable.dataSource = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.lat = location.latitude
        self.long = location.longitude
        // PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
        let query = PFQuery(className: "riderRequest")
        query.whereKeyExists("username")
        query.findObjectsInBackground { (objects, error) in
            
            self.usernames.removeAll()
            self.locations.removeAll()
            
            for object in objects! {
                
                let longgg = object["locations"] as! PFGeoPoint
                
                query.whereKey("locations", nearGeoPoint: longgg, withinMiles: 1.0)
                query.limit = 2
                
                self.locations.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                
                let requestLocation = CLLocationCoordinate2D(latitude: longgg.latitude, longitude: longgg.longitude)
                
                let requestCLlocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
                
                let groomerLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                
                let distance = groomerLocation.distance(from: requestCLlocation)
                
                self.distances.append(distance/1000)
                
                
                if let username = object["username"] as? String {
                    
                    self.usernames.append(username)
                    
                }
            }
        }
        
        self.riderRequestTable.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let distanceDouble = Double(distances[indexPath.row])
        
        let roundedDouble = Double(round(distanceDouble * 10) / 10 )
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestedCell", for: indexPath) as! RequestTableViewCell
        
        cell.userRequest.text = usernames[indexPath.row] + " " + String(roundedDouble) + "km away"
        
        return cell
    }
    
    
    @IBAction func logOutVendor(_ sender: AnyObject
        ) {
        
        PFUser.logOut()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openGroomerMap" {
            
            if let destination = segue.destination as? ViewRequests {
                
                destination.requestedLocation = locations[(riderRequestTable.indexPathForSelectedRow?.row)!]
            }
        }
    }
}

