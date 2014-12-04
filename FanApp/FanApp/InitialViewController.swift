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
        
    }
    @IBOutlet var myTicketLabel: UIButton!
    @IBOutlet var purchaseTicketLabel: UIButton!
    @IBOutlet var myAccountLabel: UIButton!
    @IBOutlet var intialImage: UIImageView!
    
    /*@IBAction func myTicketsPressed(sender: AnyObject) {
        let vs: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("TicketList")
        self.showViewController(vs as UIViewController, sender: vs)
    }*/
}
