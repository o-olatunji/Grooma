//
//  ViewController.swift
//  VetsNow
//
//  Created by Miles Fishman on 9/27/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit

class ViewController: UIViewController {
    
    var myBool = false
    
    @IBOutlet weak var FBButtonAppearance: UIButton!
    
    @IBAction func FBLogInButton(_ sender: AnyObject) {
        
        self.myBool = true
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) -> Void in
            
            if let error = error {
                
                print(error)
            }
            else {
                
                if let user = user{
                    let deadlineTime = DispatchTime.now()
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        print(user)
                        //self.performSegue(withIdentifier: "signIn", sender: self)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBButtonAppearance.layer.cornerRadius = 9
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if (FBSDKAccessToken.current() != nil) {
//            performSegue(withIdentifier: "signIn", sender: self)
//        }
        
                if myBool == true {
        
                    performSegue(withIdentifier: "signIn", sender: self)
                }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
