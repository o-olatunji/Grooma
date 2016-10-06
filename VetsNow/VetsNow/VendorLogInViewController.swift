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
        
        view.endEditing(true)
        
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
                let deadlineTime = DispatchTime.now()
                
                DispatchQueue.main.asyncAfter(deadline: deadlineTime){
                    
                    self.usernameField.text?.removeAll()
                    self.passwordField.text?.removeAll()
                    
                    self.performSegue(withIdentifier: "vendorSignedIn", sender: self)
                    
                    let alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
            else {
                
                let alert = UIAlertView(title: "Error", message: "The username and/or password you selected is invalid.", delegate: self, cancelButtonTitle: "OK")
                
                alert.show()
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        PFUser.logOut()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
}



































