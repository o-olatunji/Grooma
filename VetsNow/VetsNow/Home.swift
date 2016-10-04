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

class Home : UIViewController    {
    
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
    
}

   
