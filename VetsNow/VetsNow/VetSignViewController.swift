//
//  VetSignViewController.swift
//  VetsNow
//
//  Created by Admin on 10/2/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse

class VetSignViewController : UIViewController {
    
    @IBAction func signUpGroomer(_ sender: AnyObject) {
        
        myMethod()
        
        groomerName.text?.removeAll()
        groomerCertificate.text?.removeAll()
        groomerPassword.text?.removeAll()
        grommerEmail.text?.removeAll()
        
        
}
    @IBOutlet weak var groomerName: UITextField!
    
    @IBOutlet weak var grommerEmail: UITextField!
    
    @IBOutlet weak var groomerPassword: UITextField!
    
    @IBOutlet weak var groomerCertificate: UITextField!
    
    
    override func viewDidLoad() {
        
       
        
    }
    func myMethod() {
        let user = PFUser()
        user.username = groomerName.text
        user.password = groomerPassword.text
        user.email = grommerEmail.text
        // other fields can be set just like with PFObject
        user["Certificate"] = groomerCertificate.text
        user["Groomer"] = true
        
        user.signUpInBackground {
            (succeeded, errorr) -> Void in
            if let error = errorr {
                
                _ = ErrorUserInfoKey(rawValue: String())
                
                print(error, user)
            }
            else {
                
                print("WOOT")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}




