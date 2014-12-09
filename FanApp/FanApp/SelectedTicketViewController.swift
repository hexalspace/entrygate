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

class SelectedTicketViewController: UIViewController/*, CBPeripheralManagerDelegate, CBCentralManagerDelegate*/ {
    
    let DEMO_MODE = false
    
    //Parameters should be self, nil. Not working without nil, nil
    var bluetoothManager : FanBluetoothManager!

    
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
    
    var possibleColors = [UIColor.redColor(), UIColor.magentaColor(), UIColor.blueColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.blackColor(), UIColor.orangeColor(), UIColor.grayColor(), UIColor.purpleColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //peripheralManager = CBPeripheralManager(delegate self, queue: nil
        
        //set up view's visual elements
        searchSwitch.setOn(false, animated:false)
        ticketNameLabel.text = ticketName
        venueLabel.text = venue
        dateLabel.text = date
        seatLabel.text = seat
        ticketIdLabel.text = id
        connectedLabel.hidden = true
        pleaseShowLabel.hidden = true

        
        //Set up views bluetooth backend
        bluetoothManager = FanBluetoothManager(view: self, eventName: ticketName, ticketID: id)
        searchButtonUpdated(self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sucessfulConnection(){
        if(DEMO_MODE){
            colorView.backgroundColor = possibleColors[Int(arc4random_uniform(UInt32(possibleColors.count)))]
        }
        else{
            var rawColorData : NSData = bluetoothManager.getValidationColor()
            colorView.backgroundColor = getColor(dataToString(rawColorData))
            //do something to set colorView to the new color
        }
        searchSwitch.hidden = true
        usherLabel.hidden = true
        searchWheel.stopAnimating()
        searchWheel.hidden = true
        
        connectedLabel.hidden = false
        pleaseShowLabel.hidden = false
        
        if(DEMO_MODE){
            var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("ticketValidated"), userInfo: nil, repeats: false)
        }
        
    }
    
    func ticketValidated(){
        if(!DEMO_MODE){
            var rawValidationDate = bluetoothManager.getValidationStatus()
        }
        
        //change to actual logic after we figure out processing
        if(true){ //Usher validates ticket
            bluetoothManager.stopAdvertising()
            self.performSegueWithIdentifier("successSegue", sender: self)
        }
        else if(false){ //Usher invalidates ticket
            
        }
        else{ //Something goes wrong
            
        }
    
    
    }
    
    func refreshUI(){
        searchButtonUpdated(self)
        //peripheralManagerDidUpdateState(peripheralManager)
        
    }
    
    @IBAction func searchButtonUpdated(sender: AnyObject) {
        if(searchSwitch.on){
            //usherLabel.text = "Searching for nearby usher..."
            usherLabel.hidden = true
            searchWheel.startAnimating()
            searchWheel.hidden = false
            if(DEMO_MODE){
                var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("sucessfulConnection"), userInfo: nil, repeats: false)
            }
            else{
                bluetoothManager.startAdvertising()
            }
        }
        else{
            usherLabel.hidden = false
            searchWheel.stopAnimating()
            searchWheel.hidden = true
            if(DEMO_MODE){
                
            }
            else{
                bluetoothManager.stopAdvertising()
            }
        }
    }
    
    
    @IBAction func helpPressed(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "Help"
        alert.message = "Tap the switch above \"Search for Usher\" to search for an usher to validate your ticket. Connection wil be handled automatically"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    


}

