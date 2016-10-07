//
//  ServiceTableViewMenu.swift
//  VetsNow
//
//  Created by Admin on 10/3/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit
import SideMenu
import Parse

var profileImage: UIImage?

class ServiceTableViewMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var profilePicUser: UIImageView!
    
    var services:[String] = ["Your Pet", "Favorites", "About-Us", "Pet Stores"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .menuDissolveIn
        SideMenuManager.menuAnimationPresentDuration = 0.5
        
        profilePicUser.image = profileImage
        profilePicUser.layer.masksToBounds = true
        profilePicUser.layer.cornerRadius = 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuItemTableViewCell {
            
          
            cell.menuItem.textColor = UIColor.white
            cell.menuItem.text = services[indexPath.row]
        }
        return UITableViewCell()
    }
    
}
