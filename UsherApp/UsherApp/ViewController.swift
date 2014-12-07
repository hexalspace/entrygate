//
//  ViewController.swift
//
//  Created by Jacob Jarecki on 11/2/14.
//  Copyright (c) 2014 Jacob Jarecki. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // Usher App Constants
    let MAX_FANS = 9
    let MAX_FAN_GROUPS = 1
    let COL_VIEW_TOP_INSET  = 150
    let COL_VIEW_BOTTOM_INSET = 0
    let COL_VIEW_LEFT_INSET = 20
    let COL_VIEW_RIGHT_INSET = 20
    let COL_VIEW_CELL_SIZE = 90
    let DEBUG_VIEW_MAX_LINES = 8

    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    // UI Elements Added via Storyboard
    @IBOutlet var scanSwitch : UISwitch!
    @IBOutlet var ticketNumberLabel :UILabel!
    @IBOutlet var collectionView : UICollectionView!

    // Modifiable Class Elements
    var debugTextView : UITextView!
    var ticketNumber : String = ""
    var eventID : String = ""
    var nextCell : Int = 0
    var debugCount  = 0
    var centralManager : CBCentralManager!
    var peripheralUser : CBPeripheral!
    
    //// UI Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Bluetooth
        centralManager = CBCentralManager(delegate: self, queue:nil)

        // Initialize Collection View
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: CGFloat(COL_VIEW_TOP_INSET), left: CGFloat(COL_VIEW_LEFT_INSET), bottom: CGFloat(COL_VIEW_BOTTOM_INSET), right: CGFloat(COL_VIEW_RIGHT_INSET))
        layout.itemSize = CGSize(width: COL_VIEW_CELL_SIZE, height: COL_VIEW_CELL_SIZE)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)

        if (TEST){
            // Add test buttons
            var b1 = UIButton.buttonWithType(UIButtonType.System) as UIButton
            b1.frame = CGRectMake(0, 0, 100, 50)
            b1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            b1.setTitle("addFakePeriperhal", forState: UIControlState.Normal)
            b1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            b1.addTarget(self, action: "addFakePeriperhal:", forControlEvents: UIControlEvents.TouchUpInside)
            b1.backgroundColor = UIColor.lightGrayColor()
            self.view.addSubview(b1)

            var b2 = UIButton.buttonWithType(UIButtonType.System) as UIButton
            b2.setTitle("refreshPeripheralState", forState: UIControlState.Normal)
            b2.frame = CGRectMake(0, 50, 100, 50)
            b2.imageEdgeInsets = UIEdgeInsets(top: 60, left: 20, bottom: 0, right: 0)
            b2.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            b2.addTarget(self, action: "refreshPeripheralState:", forControlEvents: UIControlEvents.TouchUpInside)
            b2.backgroundColor = UIColor.lightGrayColor()
            self.view.addSubview(b2)
        }

        if (DEBUG){
            debugTextView = UITextView()
            debugTextView.frame = CGRectMake(screenWidth/2 - screenWidth/2, screenHeight/2 + screenHeight/4, screenWidth, screenHeight/2)
            debugTextView.text = "Debug Log:"
            self.view.addSubview(debugTextView)
        }
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startScan(sender: AnyObject){
        if (scanSwitch.on){
            let services = [TM_FAN_CLIENT_COMMS_SERVICE]
            centralManager.scanForPeripheralsWithServices(services, options: nil)
            debugPrint("Scan for peripherals started")
        }
        else{
            centralManager.stopScan()
            debugPrint("Scan for peripherals stopped")
        }
    }
    
    func refreshUI(){
        ticketNumberLabel.text = "Ticker number: " + self.ticketNumber + " for" + self.eventID
    }

    func debugPrint(text : String){
        if (DEBUG){
            if (debugCount > DEBUG_VIEW_MAX_LINES){
                debugTextView.text = "Debug Log:" + "\n>  " + text
                debugCount = 0
            }
            else {
                debugTextView.text = debugTextView.text! + "\n>  " + text
                debugCount++
            }
        }
        println(text)
    }
    
    //// Colection View Delegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return MAX_FAN_GROUPS
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MAX_FANS
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as CollectionViewCell
        debugPrint("Selected: \(cell.ticketNumber)");

        cell.active = false
        cell.peripheral = nil
        cell.backgroundColor = UIColor.lightGrayColor()
    }
    
    
    //// CBDelegateManager Functions
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if (nextCell < MAX_FANS){
            centralManager.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.delegate = self
        debugPrint("Connected to discovered peripheral: \(peripheral.name)")
        if (nextCell < MAX_FANS){
            var indexPath = NSIndexPath(forRow: nextCell, inSection: 0)
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as CollectionViewCell
            cell.peripheral = peripheral
            cell.backgroundColor = UIColor.blueColor()
            nextCell++
            peripheral.discoverServices([TM_FAN_CLIENT_COMMS_SERVICE])
        }
    }

    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {

        var j = 0

        // Invalidate disconnected peripheral
        for i in 0...MAX_FANS-1 {
            var curPath = NSIndexPath(forRow: i, inSection: 0)
            var cell = collectionView.cellForItemAtIndexPath(curPath) as CollectionViewCell
            if (cell.peripheral == peripheral){
                cell.active = false
                cell.peripheral = nil
                j = i
            }
        }

        // Shift other peripherals up
        for i in j...MAX_FANS-1 {
            var curPath = NSIndexPath(forRow: i, inSection: 0)
            var nextPath = NSIndexPath(forRow: i+1, inSection: 0)
            if (i != MAX_FANS-1){
                var cell = collectionView.cellForItemAtIndexPath(curPath) as CollectionViewCell
                var adjCell = collectionView.cellForItemAtIndexPath(nextPath) as CollectionViewCell
                cell.active = adjCell.active
                cell.peripheral = adjCell.peripheral
                cell.backgroundColor = adjCell.backgroundColor
            }
            else {
                var cell = collectionView.cellForItemAtIndexPath(curPath) as CollectionViewCell
                cell.active = false
                cell.peripheral = nil
                cell.backgroundColor = UIColor.lightGrayColor()
            }
        }
        nextCell--
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch centralManager.state {
        case .PoweredOff:
            debugPrint("Bluetooth is powered off")
            break
        case .PoweredOn:
            debugPrint("Bluetooth is powered on")
            break
        case .Resetting:
            debugPrint("Bluetooth is currently resetting")
            break
        case .Unauthorized:
            debugPrint("Bluetooth access is unauthorized")
            break
        case .Unknown:
            debugPrint("Bluetooth status is unknown")
            break
        case .Unsupported:
            debugPrint("Bluetooth is not supported on this device")
            break
        default:
            debugPrint("Device is a potato")
            break
        }
    }

    //// CBPeripheralDelegate Functions
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            peripheral.discoverCharacteristics([TM_FAN_CLIENT_EVENT_NAME_CHARACTERISTIC, TM_FAN_CLIENT_TICKET_ID_CHARACTERISTIC], forService: service as CBService)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        for characteristic in service.characteristics {
            peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!){
        if characteristic.properties == CBCharacteristicProperties.Read {
            var dataString = dataToString(characteristic.value)
            switch characteristic.UUID {
                case TM_FAN_CLIENT_EVENT_NAME_CHARACTERISTIC:
                    debugPrint("Recieved CLIENT_EVENT_NAME " + dataString)
                    self.eventID = dataString
                    break
                case TM_FAN_CLIENT_TICKET_ID_CHARACTERISTIC:
                    debugPrint("Recieved CLIENT_TICKET_ID " + dataString)
                    self.ticketNumber = dataString
                    break
                default:
                    break
            }
            refreshUI()
        }
    }

    //// Testing Functions
    @IBAction func addFakePeriperhal(sender: AnyObject){
        if (nextCell < MAX_FANS){
            var indexPath = NSIndexPath(forRow: nextCell, inSection: 0)
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as CollectionViewCell
            cell.peripheral = nil
            cell.backgroundColor = UIColor.blueColor()
            nextCell++
        }
    }

    @IBAction func refreshPeripheralState(sender: AnyObject){
        var j = 0

        // Shift other peripherals up
        for i in j...MAX_FANS-1 {
            var curPath = NSIndexPath(forRow: i, inSection: 0)
            var nextPath = NSIndexPath(forRow: i+1, inSection: 0)
            if (i != MAX_FANS-1){
                var cell = collectionView.cellForItemAtIndexPath(curPath) as CollectionViewCell
                var adjCell = collectionView.cellForItemAtIndexPath(nextPath) as CollectionViewCell
                cell.active = adjCell.active
                cell.peripheral = adjCell.peripheral
                cell.backgroundColor = adjCell.backgroundColor
            }
            else {
                var cell = collectionView.cellForItemAtIndexPath(curPath) as CollectionViewCell
                cell.active = false
                cell.peripheral = nil
                cell.backgroundColor = UIColor.lightGrayColor()
            }
        }
        nextCell--
    }
}

