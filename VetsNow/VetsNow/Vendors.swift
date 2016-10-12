//
//  Vendors.swift
//  VetsNow
//
//  Created by Olamide Olatunji on 10/11/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit

struct Vendors {
    
    let name: String
    let  profilePicture: UIImage
    let  coordinates: Double
    
    
   static func from(dictionary: NSDictionary) -> Vendors? {
        
        guard let name = dictionary["name"] as? String,
            let coordinates = dictionary["coordinates"] as? Double,
            let profilePicture = dictionary["ProfilePicure"] as? UIImage
            
            else { return nil }
        
    
        return Vendors(name: name, profilePicture: profilePicture, coordinates: coordinates)
    }
}

