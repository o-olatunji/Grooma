//
//  GroomerOrOwner.swift
//  VetsNow
//
//  Created by Miles Fishman on 10/6/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit


class GroomerOrOwner : UIViewController {
    
    
    @IBOutlet weak var petOwner: UIButton!
    
    @IBOutlet weak var groomer: UIButton!
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        petOwner.layer.cornerRadius = 9
        petOwner.layer.borderWidth = 0
        petOwner.layer.borderColor = UIColor.black.cgColor
        
        groomer.layer.cornerRadius = 9
        petOwner.layer.borderWidth = 0
    }
    
}
