//
//  Home.swift
//  VetsNow
//
//  Created by Admin on 9/28/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import MapKit
import CoreLocation


class Home : UIViewController, CLLocationManagerDelegate , MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate   {
    
    let services = ["Clean Eyes", "Clean Ears", "Trim Paw Pads", "Clip Nails", "Final Brush and fluff"]
    
    
    func numberOfSections(in: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        let numberOfRows = services.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Services Cell", for: indexPath)
        let service = services[indexPath.row]
        cell.textLabel?.text = service
    
        
        return cell
    }
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func logOutAction(_ sender: AnyObject) {
        
        PFUser.logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var FBProfilePic: UIImageView!
    
    func getUserInfoFromFB(){
        
        let graphRequest = FBSDKGraphRequest(graphPath:"me",parameters: ["fields":"id, name, gender, email"])
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            
            if self.FBProfilePic.image == nil {
                
                if error != nil{
                    let conn = connection
                    print(error)
                    print(conn)
                }
                else if let result = result {
                    
                    let userId = result as! NSDictionary
                    let realId = userId["id"] as! String
                    
                    PFUser.current()?["name"] = userId["name"]
                    PFUser.current()?["email"] = userId["email"]
                    PFUser.current()?.saveInBackground(block: { (true, error) in
                        if error != nil {
                            try! PFUser.current()?.save()
                        }
                        else {
                            print(error)
                        }
                    })
                    let profilePic = "https://graph.facebook.com/" + realId + "/picture?type=large"
                    
                    if let profileUrl = URL(string: profilePic) {
                        guard let data = try? Data(contentsOf: profileUrl) else {return}
                        self.FBProfilePic.isHidden = false
                        self.FBProfilePic.image = UIImage(data: data)
                        profileImage = UIImage(data: data)
                    }
                }
            }
        })
        connection.start()
    }
    
    // ----- MAP -----//
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin: MKPlacemark? = nil
    var resultSearchController: UISearchController? = nil
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getUserInfoFromFB()
        
        logOutButton.layer.cornerRadius = 15
        logOutButton.layer.borderWidth = 2
        logOutButton.layer.masksToBounds = true
        
        FBProfilePic.layer.cornerRadius = 25
        FBProfilePic.layer.borderWidth = 2
        FBProfilePic.layer.masksToBounds = true
        
        //Create 2D coordiantes & set region:
        let location = locationManager.location
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let latDelta :CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location2:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location2, span)
        mapView.setRegion(region,animated: true)
        
        //Create Annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
    
    //Location Delegate Methods
    
    private func locationManager(manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error : NSError) {
        print ("Errors:" + error.localizedDescription)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
}
