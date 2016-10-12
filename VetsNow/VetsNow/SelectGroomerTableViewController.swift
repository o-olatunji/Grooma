//
//  SelectGroomerTableViewController.swift
//  VetsNow
//
//  Created by Olamide Olatunji on 10/11/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit
import Parse

class SelectGroomerTableViewController: UITableViewController {
    
    
    let main = OperationQueue.main
    var images:[UIImage] = []
    var names: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieveNames()
        getImages()
        
    }
    
//    func retrieveNames() {
//        var query:PFQuery = PFQuery(className: "_User")
//        query.findObjectsInBackground {
//            (objects, error) -> Void in
//            
//            for object in objects! {
//                let name:String? = (object as PFObject)["name"] as? String
//                if name != nil {
//                    self.names.append(name!)
//                    
//                    print("name added")
//                }
//            }
//            self.tableView.reloadData()
//        }
//    }
    
    
    func getImages() {
        var query:PFQuery = PFQuery(className: "_User")
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
}
