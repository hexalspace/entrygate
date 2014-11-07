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

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let TM_USHER_CLIENT_COMMS = CBUUID(string: "BA0A5518-4D18-443A-817F-D726062085BD")
    let TM_USHER_CLIENT_COMMS_CHARACTERICS = CBUUID(string: "C04761A0-51E9-4653-B51D-FC93C3B691CF")
    
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
    
    //// UI Functions
    
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
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.delegate = self
        println("Connected to discovered peripheral: \(peripheral.name)")
        // May not be needed since we know what service to expect here
        peripheral.discoverServices([TM_USHER_CLIENT_COMMS])
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
    }
    
    
    /// CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            peripheral.discoverCharacteristics([TM_USHER_CLIENT_COMMS_CHARACTERICS], forService: service as CBService)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        for characteristic in service.characteristics {
            peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!){
        if characteristic.properties == CBCharacteristicProperties.Read {
            // Convert characteristic.value to an integer to set ticketNumber
            self.ticketNumber = 0
            refreshUI()
        }
    }
    
    
    
}

