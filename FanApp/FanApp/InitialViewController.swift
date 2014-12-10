//
//  InitialViewController.swift
//  FanApp
//
//  Created by Ryan Dall on 12/4/14.
//  Copyright (c) 2014 TM-UCLA-BLE. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blueColor()
        
    }
    @IBOutlet var myTicketLabel: UIButton!
    @IBOutlet var purchaseTicketLabel: UIButton!
    @IBOutlet var myAccountLabel: UIButton!
    @IBOutlet var intialImage: UIImageView!
    
    
    @IBAction func helpPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Help", message: "Tap \"My Tickets\" to view all your purchased tickets", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func purchaseTicketsPressed(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "Feature Not Implemented"
        alert.message = "This feature is currently under construction. Check back later!"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    @IBAction func myAccountPressed(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "Feature Not Implemented"
        alert.message = "This feature is currently under construction. Check back later!"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    

}
