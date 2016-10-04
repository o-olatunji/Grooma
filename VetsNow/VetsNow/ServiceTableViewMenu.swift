//
//  ServiceTableViewMenu.swift
//  VetsNow
//
//  Created by Admin on 10/3/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit
import SideMenu

class ServiceTableViewMenu: UITableViewController {
    var services:[String] = ["Ear Cleaning:$18", "Wash: $20", "Full Grooming: $20","Flea & Tick Search: $20"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    SideMenuManager.menuFadeStatusBar = false

}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return services.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.textColor = UIColor.black

        cell.textLabel?.text = services[indexPath.row]
        
        return cell
    }
    

}

