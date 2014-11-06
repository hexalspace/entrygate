//
//  ViewController.swift
//  Test
//
//  Created by Jacob Jarecki on 11/2/14.
//  Copyright (c) 2014 Jacob Jarecki. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore

class ViewController: UIViewController, CBCentralManagerDelegate {
    
    let TM_USHER_CLIENT_COMMS = CBUUID(string: "BA0A5518-4D18-443A-817F-D726062085BD")
    
    var ticketNumber : Int = 0
    
    var centralManager : CBCentralManager!
    
    var peripheralUser : CBPeripheral!
    
    @IBOutlet var scanSwitch : UISwitch!
    
    @IBOutlet var ticketNumberLabel :UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue:nil)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////			 UI Functions
    
    @IBAction func startScan(sender: AnyObject){
        if (scanSwitch.on){
            let services = [TM_USHER_CLIENT_COMMS]
            centralManager.scanForPeripheralsWithServices(services, options: nil)
            println("Scan started")
        }
        else{
            centralManager.stopScan()
            println("Scan stopped")
        }
    }
    
    @IBAction func tapView(sender : AnyObject){
    }
    
    func refreshUI(){
        ticketNumberLabel.text = "Ticker number: \(ticketNumber)"
    }
    
    //// CBDelegateManager
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
    }
    
    
    
    
    
}

