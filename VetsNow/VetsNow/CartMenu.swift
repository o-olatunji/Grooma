//
//  CartMenu.swift
//  VetsNow
//
//  Created by Admin on 10/8/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

var arr: [Int] = []
var priceTotal:Int?

class CartMenu : UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var mybagtableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mybagtableView.delegate = self
        mybagtableView.dataSource = self
        
        SideMenuManager.menuEnableSwipeGestures = false
        SideMenuManager.menuWidth = 300
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .viewSlideInOut
        SideMenuManager.menuAnimationPresentDuration = 0.3
        SideMenuManager.menuShadowColor = UIColor.clear
        
        totalCost.text = "Total - $" + String(describing: sumedArr)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myBagCell", for: indexPath)
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 26)
        cell.textLabel?.text = cart[indexPath.row] + " " + userTotalCount[indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteBagitem = UITableViewRowAction(style: .normal, title: " Delete") { action, index in
            
            userTotalCount.remove(at: indexPath.row)
            cart.remove(at: indexPath.row)
            sumedArr = sumedArr - arr[indexPath.row]
            let newTotal = sumedArr
            self.totalCost.text? = "Total - $\(newTotal)"
            self.totalCost.reloadInputViews()
            arr.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }
        deleteBagitem.backgroundColor = UIColor.red
        
        return [deleteBagitem]
    }
}
