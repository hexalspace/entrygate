//
//  ViewController.swift
//  FanApp
//
//  Created by Ryan Dall on 11/6/14.
//  Copyright (c) 2014 TM-UCLA-BLE. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore

class ViewController: UIViewController {
    
    
    //BlueTooth standard UUIDs from developer.bluetooth.org/gatt/services/pages/ServicesHome.aspx
    let TM_FAN_DEVICE_INFO_SERVICE_UUID = "180A"
    let TM_FAN_USER_DATA_SERVICE_UUID = "181C"
    
    var ticketID: UInt32 = 1
    func setRandomTicketID(){
        self.ticketID = arc4random_uniform(899999) + 100000
    }
    
    var peripheralManager : CBPeripheralManager!
    
    @IBOutlet var ticketIdLabel: UILabel!
    //Add Bluetooth standard UUIDs from developer.bluetooth.org/gatt/characteristics/pages/CharacteristicsHome.aspx here

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //peripheralManager = CBPeripheralManager(delegate self, queue: nil)
        setRandomTicketID()
        ticketIdLabel.text = "Your ticket ID is \(ticketID)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshUI(){
        self.ticketIdLabel.text = "Your ticket ID is \(ticketID)"
        
    }
    
    @IBAction func generateNewTicketID(sender: AnyObject) {
        setRandomTicketID()
        refreshUI()
    }


}

