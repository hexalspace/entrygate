//
//  ViewController.swift
//
//  Created by Jacob Jarecki on 11/2/14.
//  Copyright (c) 2014 Jacob Jarecki. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var ticketNumber : Int32 = 0
    var centralManager : CBCentralManager!
    var peripheralUser : CBPeripheral!
    
    @IBOutlet var scanSwitch : UISwitch!
    @IBOutlet var ticketNumberLabel :UILabel!
    
    //// UI Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue:nil)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startScan(sender: AnyObject){
        if (scanSwitch.on){
            let services = [TM_USHER_CLIENT_COMMS_SERVICE]
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
    
    //// CBDelegateManager Functions
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.delegate = self
        println("Connected to discovered peripheral: \(peripheral.name)")
        // May not be needed since we know what service to expect here
        peripheral.discoverServices([TM_USHER_CLIENT_COMMS_SERVICE])
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch centralManager.state {
        case .PoweredOff:
            println("Bluetooth is powered off")
            break
        case .PoweredOn:
            println("Bluetooth is powered on")
            break
        case .Resetting:
            println("Bluetooth is currently resetting")
            break
        case .Unauthorized:
            println("Bluetooth access is unauthorized")
            break
        case .Unknown:
            println("Bluetooth status is unknown")
            break
        case .Unsupported:
            println("Bluetooth is not supported on this device")
            break
        default:
            println("Device is a potato")
            break
        }
    }
    
    /// CBPeripheralDelegate Functions
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            peripheral.discoverCharacteristics([TM_USHER_CLIENT_COMMS_CHARACTERIC_TICKET, TM_USHER_CLIENT_COMMS_CHARACTERIC_STATUS], forService: service as CBService)
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

