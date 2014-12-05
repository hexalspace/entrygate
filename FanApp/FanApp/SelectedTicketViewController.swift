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

class SelectedTicketViewController: UIViewController, CBPeripheralManagerDelegate, CBCentralManagerDelegate {
    
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

    
    var ticketName = "None"
    var venue = "None"
    var date = "0/0/0"
    var seat = "None"
    var id = "00000"
    
    @IBOutlet var ticketNameLabel: UILabel!
    @IBOutlet var venueLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
    @IBOutlet var ticketIdLabel: UILabel!
    @IBOutlet var connectedLabel: UILabel!
    @IBOutlet var pleaseShowLabel: UILabel!
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var searchSwitch: UISwitch!
    @IBOutlet var usherLabel: UILabel!
    @IBOutlet var searchWheel: UIActivityIndicatorView!
    
    var possibleColors = [UIColor.redColor(), UIColor.magentaColor(), UIColor.blueColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.blackColor(), UIColor.orangeColor(), UIColor.grayColor(), UIColor.brownColor(), UIColor.purpleColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //peripheralManager = CBPeripheralManager(delegate self, queue: nil
        searchSwitch.setOn(false, animated:false)
        setupServices()
        ticketNameLabel.text = ticketName
        venueLabel.text = venue
        dateLabel.text = date
        seatLabel.text = seat
        ticketIdLabel.text = id
        connectedLabel.hidden = true
        pleaseShowLabel.hidden = true
        searchButtonUpdated(self)
        peripheralManagerDidUpdateState(peripheralManager)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupServices(){
        peripheralManager.addService(CBMutableService(type: TM_FAN_USER_DATA_SERVICE_UUID, primary: true))
        peripheralManager.addService(CBMutableService(type: TM_FAN_DEVICE_INFO_SERVICE_UUID, primary: false))
    }
    
    func sucessfulConnection(){
        colorView.backgroundColor = possibleColors[Int(arc4random_uniform(UInt32(possibleColors.count)))]
        searchSwitch.hidden = true
        usherLabel.hidden = true
        searchWheel.stopAnimating()
        searchWheel.hidden = true
        
        connectedLabel.hidden = false
        pleaseShowLabel.hidden = false
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("ticketValidated"), userInfo: nil, repeats: false)
        
    }
    
    func ticketValidated(){
        self.performSegueWithIdentifier("successSegue", sender: self)
        
    }
    
    func refreshUI(){
        searchButtonUpdated(self)
        peripheralManagerDidUpdateState(peripheralManager)
        
    }
    
    @IBAction func searchButtonUpdated(sender: AnyObject) {
        if(searchSwitch.on){
            usherLabel.text = "Searching for nearby usher..."
            searchWheel.startAnimating()
            searchWheel.hidden = false
            var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("sucessfulConnection"), userInfo: nil, repeats: false)
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

