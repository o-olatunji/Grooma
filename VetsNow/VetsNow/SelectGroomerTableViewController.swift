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
        
        retrieveMessages()
        
    }
    
        func retrieveMessages() {
            var userArray: [String] = []
            var query:PFQuery = PFQuery(className: "User")
            var currentUser = query.whereKey("username", equalTo: PFUser.current())
            currentUser.findObjectsInBackground {
                (objects, error) -> Void in
                
                for object in objects! {
                    let name:String? = (object as PFObject)["name"] as? String
                    if name != nil {
                        self.names.append(name!)
                    }
                }
                self.tableView.reloadData()
            }
        }
    





    
   /* func getImages(objects:[PFObject]) {
        
        for object in objects {
            
            let thumbNail = object["ProfilePicure"] as! PFFile
            
            thumbNail.getDataInBackground(block: { (data, error) in
                
                if error == nil {
                    
                    let image = UIImage(data:data!)
                    //image object implementation
                    self.images.append(image!)
                    
                    print("image added!")
                }
                
                self.main.addOperation {
                    self.tableView.reloadData()
                    
                    print("it works!")
                }
                
            })
            
        }
    }
    
    func getNames() {
        let query = PFQuery(className:"User")
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    
                    self.names.append(object["name"] as! String)
                    
                }
                self.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
            else {
                print(error)
            }
        }
        
        
    } */
    
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groomers", for: indexPath) as! SelectGroomerCell
        
        // cell.vendorProfilePic.image = images[indexPath.row]
     cell.companyName.text = names[indexPath.row]
        
        return cell
        
    }
}
