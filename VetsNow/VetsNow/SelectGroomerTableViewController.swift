//
//  SelectGroomerTableViewController.swift
//  VetsNow
//
//  Created by Olamide Olatunji on 10/11/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class SelectGroomerTableViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView2: MKMapView!
    var locationManager2 = CLLocationManager()
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
    let main = OperationQueue.main
    var images:[UIImage] = []
    var names: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager2 = CLLocationManager()
        locationManager2.delegate = self
        locationManager2.desiredAccuracy = kCLLocationAccuracyBest
        locationManager2.distanceFilter = kCLDistanceFilterNone
        locationManager2.requestWhenInUseAuthorization()
        locationManager2.startUpdatingLocation()
        
        mapView2.delegate = self
        mapView2.showsUserLocation = true
        
        //retrieveNames()
        getImages()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Create Map, 2D coordiantes, and set region with annotation:
        let location2 = locationManager2.location
        let center = CLLocationCoordinate2D(latitude: location2!.coordinate.latitude, longitude: location2!.coordinate.longitude)
        let latDelta :CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location3:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (location2?.coordinate.latitude)!, longitude: (location2?.coordinate.longitude)!)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location3, span)
        mapView2.setRegion(region,animated: true)
        
        self.latitude = location3.latitude
        self.longitude = location3.longitude
        
        //Create Annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView2.addAnnotation(annotation)
        mapView2.removeAnnotations(mapView2.annotations)
    }
    
    //Location Delegate Methods:
    private func locationManager(manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
    }
    private func locationManager(manager: CLLocationManager, didFailWithError error : NSError) {
        print ("Errors:" + error.localizedDescription)
    }
    
    func getImages() {
        let query:PFQuery = PFQuery(className: "_User")
        query.findObjectsInBackground {
            (objects, error) -> Void in
            
            for object in objects! {
                
                let thumbNail = object["ProfilePicure"] as! PFFile
                let titles = object["name"] as! String
                thumbNail.getDataInBackground(block: { (data, error) in
                    
                    self.names.append(titles)
                    let image = UIImage(data:data!)
                    
                    self.images.append(image!)
                    
                    print("image added!")
                    
                    
                    self.main.addOperation {
                        self.tableView.reloadData()
                        
                        print("it works!")
                    }
                    
                })
                
            }
        }
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestGroomerButton(_ sender: AnyObject) {
        
        let riderRequest = PFObject(className: "riderRequest")
        guard let currentUser = PFUser.current() else { return }
        
        riderRequest["username"] = currentUser.email
        riderRequest["locations"] = PFGeoPoint(latitude: self.latitude, longitude: self.longitude)
        
        riderRequest.saveInBackground { (success, error) in
            
            guard error == nil else { print("error saving rider request: \(error)") ; return }
            if success {
                print("success")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groomers", for: indexPath) as! SelectGroomerCell
        
        cell.vendorProfilePic.image = images[indexPath.row]
        cell.companyName.text = names[indexPath.row]
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "groomers", for: indexPath) as! SelectGroomerCell
        
        requestGroomerButton(indexPath.row as AnyObject)
    }
}
