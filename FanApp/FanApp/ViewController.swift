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

class ViewController: UIViewController, CBPeripheralManagerDelegate, CBCentralManagerDelegate {
    
    //BlueTooth standard UUIDs from developer.bluetooth.org/gatt/services/pages/ServicesHome.aspx
    let TM_FAN_DEVICE_INFO_SERVICE_UUID = CBUUID(string:"180A")
    let TM_FAN_USER_DATA_SERVICE_UUID = CBUUID(string:"181C")
    
    let advertisementKeys: [NSString:AnyObject] = ["CBAdvertisementDataLocalNameKey": "TM_FANAPP", "CBAdvertisementDataServiceUUIDsKey":[]]
    
    var ticketID: UInt32 = 0
    
    func setRandomTicketID(){
        self.ticketID = arc4random_uniform(899999) + 100000
    }
    
    //Parameters should be self, nil. Not working without nil, nil
    var peripheralManager = CBPeripheralManager(delegate: nil, queue: nil)
    //peripheralManager.addService(CBMutableService(UUID: TM_FAN_USER_DATA_SERVICE_UUID, isPrimary: true))
    //peripheralManager.addService(CBMutableService(UUID: TM_FAN_DEVICE_INFO_SERVICE_UUID, isPrimary: false))
    
    
    
    @IBOutlet var ticketIdLabel: UILabel!
    @IBOutlet var searchSwitch: UISwitch!
    @IBOutlet var usherLabel: UILabel!
    @IBOutlet var searchWheel: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //peripheralManager = CBPeripheralManager(delegate self, queue: nil
        searchSwitch.setOn(false, animated:false)
        generateNewTicketID(self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshUI(){
        self.ticketIdLabel.text = "Your ticket ID is \(ticketID)"
        searchButtonUpdated(self)
        peripheralManagerDidUpdateState(peripheralManager)
        
    }
    
    @IBAction func generateNewTicketID(sender: AnyObject) {
        setRandomTicketID()
        refreshUI()
    }
    @IBAction func searchButtonUpdated(sender: AnyObject) {
        if(searchSwitch.on){
            usherLabel.text = "Searching for nearby usher..."
            searchWheel.startAnimating()
            searchWheel.hidden = false
        }
        else{
            usherLabel.text = "Search for usher"
            searchWheel.stopAnimating()
            searchWheel.hidden = true
        }
    }
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        switch peripheralManager.state {
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
    
    func centralManagerDidUpdateState(central: CBCentralManager!){
        
        
    }


}

