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

class Home : UIViewController, CLLocationManagerDelegate    {
    
    @IBOutlet weak var FBProfilePic: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        getUserInfoFromFB()
        
        FBProfilePic.layer.cornerRadius = 25
        FBProfilePic.layer.masksToBounds = true
    }
    
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
                    
                    PFUser.current()?.saveInBackground(block: { (Bool, error) in
                        if error != nil {
                            PFUser.current()?["name"] = userId["name"]
                            PFUser.current()?["email"] = userId["email"]
                            PFUser.current()?.saveInBackground()
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
                    }
                }
            }
        })
        connection.start()
    }
    
// ----- MAP -----

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin: MKPlacemark? = nil
    var resultSearchController: UISearchController? = nil
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
       // let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as!LocationSearchTable
        //resultSearchController = UISearchController(searchResultsController: locationSearchTable)
      //  resultSearchController?.searchResultsUpdater = locationSearchTable
        
        guard let searchBar = resultSearchController?.searchBar else { return }
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        //this passes along a handle of the mapView from the main View Controller onto the locationSearchTable
        
    }
    
    func getDirection() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    override func didReceiveMemoryWarning() {
        //super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }
    
    //Mark: - Location Delegate Methods
    
    private func locationManager(manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
        
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error : NSError) {
        print ("Errors:" + error.localizedDescription)
    }
    
}

extension Home  {
    func dropPingZoomIn(placemark: MKPlacemark) {
        //cache the pin
        selectedPin = placemark
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region,animated: true)
    }
}

extension Home: MKMapViewDelegate {
    @objc(mapView: viewForAnnotation:) func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        if #available(iOS 9.0, *) {
            pinView?.pinTintColor = UIColor.orange
        } else {
            // Fallback on earlier versions
        }
        pinView?.canShowCallout = true
        let smallSquard = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquard))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        //button.addTarget(self, action: Selector(("getDirections")), for: .touchUpInside)
        button.addTarget(self, action: #selector (getDirection), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
   
