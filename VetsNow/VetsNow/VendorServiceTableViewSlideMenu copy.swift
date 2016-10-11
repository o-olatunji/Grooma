//
//  VendorServiceTableViewSlideMenu.swift
//  VetsNow
//
//  Created by Cordero Hernandez on 10/10/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//


import UIKit
import Parse
import SideMenu

var profilePic: UIImage?

class VendorServiceSlideMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profilePictureUser: UIImageView!
    
    @IBOutlet weak var serviceMenuTable: UITableView!
    
    var profile: [String] = ["Client History", "Services", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceMenuTable.delegate = self
        serviceMenuTable.dataSource = self
        
        SideMenuManager.menuWidth = 320
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuShadowColor = UIColor.black
        SideMenuManager.menuPresentMode = .menuDissolveIn
        SideMenuManager.menuAnimationPresentDuration = 0.5
        
        profilePictureUser.image = profilePic
        profilePictureUser.layer.masksToBounds = true
        profilePictureUser.layer.cornerRadius = 90
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let theCell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath) as?
            ServiceItemTableViewCell {
            theCell.serviceItem.textColor = UIColor.white
            theCell.serviceItem.text = profile[indexPath.row]
            theCell.serviceItem.textAlignment = .center
            
        }
        return UITableViewCell()
    }
}





