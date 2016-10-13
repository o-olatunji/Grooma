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

//Global Cart/Bag variables
var cart :[String] = []
var userTotalCount: [String] = []
var sumedArr:Int = 0
//

class Home : UIViewController, CLLocationManagerDelegate , MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate   {
    
    @IBOutlet weak var bagCount: UILabel!
    @IBOutlet weak var servicesTable: UITableView!
    
    @IBAction func bagCountPressed(_ sender: AnyObject) {
        
        if userTotalCount.count == arr.count {
            
            print("ok:")
        }
        else {
            arr.removeAll()
            
            for i in userTotalCount {
                
                let price = turnMoneyStringIntoInt(string: i)
                priceTotal = price
                arr.append(priceTotal!)
            }
        }
        
        sumedArr = arr.reduce(0, {$0 + $1})
        self.bagCount.text = "\(arr.count)"
        self.bagCount.reloadInputViews()
    }
    var services = ["Clean Eyes:", "Clean Ears:", "Trim Pads:", "Clip Nails:", "Full Scrub:"]
    var servicePrices = ["$20", "$20", "$20", "$20", "$60"]
    
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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        servicesTable.delegate = self
        servicesTable.dataSource = self
        servicesTable.layer.cornerRadius = 15
        servicesTable.separatorStyle = .singleLine
        servicesTable.separatorColor = UIColor.white
        servicesTable.separatorEffect = UIVisualEffect()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    override func viewDidAppear(_ animated: Bool) {
        
        getUserInfoFromFB()

        //Create Map, 2D coordiantes, and set region with annotation:
        let location = locationManager.location
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
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
        mapView.removeAnnotations(mapView.annotations)
        
        logOutButton.layer.cornerRadius = 15
        logOutButton.layer.masksToBounds = true
        
        FBProfilePic.layer.cornerRadius = 25
        FBProfilePic.layer.borderWidth = 3
        FBProfilePic.layer.shadowOpacity = 0.2
        FBProfilePic.layer.shadowPath = UIBezierPath(roundedRect: self.view.bounds , cornerRadius: 12).cgPath
        FBProfilePic.layer.borderColor = UIColor(netHex: 0x89B1B9).cgColor
        FBProfilePic.layer.shadowColor = UIColor.black.cgColor
        FBProfilePic.layer.shadowRadius = 3.0
        FBProfilePic.layer.masksToBounds = true
        
    }
    
    //Location Delegate Methods:
    private func locationManager(manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
    }
    private func locationManager(manager: CLLocationManager, didFailWithError error : NSError) {
        print ("Errors:" + error.localizedDescription)
    }
    
    //TableView methods:
    func numberOfSections(in: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let service = services[indexPath.row]
        let servicePrice = servicePrices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 26.0)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .justified
        cell.textLabel?.text = service + "                           " + servicePrice
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favorite = UITableViewRowAction(style: .normal, title: " ❤️ ") { action, index in
            
            tableView.setEditing(false, animated: true)
            
        }
        favorite.backgroundColor = UIColor.init(netHex: 0xF7DCC5)
        
        let share = UITableViewRowAction(style: .normal, title: " 👜 ") { action, index in
            
            let service = self.services[indexPath.row]
            
            userTotalCount.append(self.servicePrices[indexPath.row])
            cart.append(service)
            
            self.bagCount.text = "\(cart.count)"
            self.bagCount.reloadInputViews()
            
            print(cart)
            print(userTotalCount)
            
            tableView.setEditing(false, animated: true)
        }
        share.backgroundColor = UIColor.init(netHex: 0xC5EFF7)
        
        return [share, favorite]
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let rotation = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotation
        
        UIView.animate(withDuration: 0.4) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func turnMoneyStringIntoInt(string:String) -> Int? {
        
        let numberPrices = string.components(separatedBy: "$")
        
        guard let numberPricesStringIntoInteger = Int(numberPrices[1]) else {
            return nil
        }
        
        return numberPricesStringIntoInteger
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
