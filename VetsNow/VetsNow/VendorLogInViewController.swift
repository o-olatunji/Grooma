//
//  VendorLogInViewController.swift
//  VetsNow
//
//  Created by Admin on 10/3/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse

class VendorLogInViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!   
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        
        
        var username = self.usernameField.text
        var password = self.passwordField.text
    
        
        if (username?.characters.count)! < 5 {
            let alert = UIAlertView(title: "Invalid username", message: "Username must be longer than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
          
        else if (password?.characters.count)! < 8 {
            let alert = UIAlertView(title: "Invalid password", message: "Password must be 8 or more characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        
        PFUser.logInWithUsername(inBackground: username!, password: password!, block: { (user, error) -> Void in
            
            
            if ((user) != nil) {
                
                let alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                
                alert.show()
            
                DispatchQueue.main.sync(execute: { () -> Void in
                    
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                    
                    self.present(viewController, animated: true, completion: nil)
                })

            } else {
                
                let alert = UIAlertView(title: "Error", message: "The username and/or password you selected is invalid.", delegate: self, cancelButtonTitle: "OK")
                
                alert.show()
                
            }
            
        })
        
    }
  
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
    }
    
}























