//
//  Vendors.swift
//  VetsNow
//
//  Created by Olamide Olatunji on 10/11/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit

class Vendors {
    
    let name: String
    let  profilePicture: UIImage
    let  coordinates: Double
    
    
    init(name: String, profilePicture: UIImage, coordinates: Double) {
        
        self.coordinates = coordinates
        self.name = name
        self.profilePicture = profilePicture
        
    }
    
    
    
}
