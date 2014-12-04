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
    let COL_VIEW_TOP_INSET  = 250
    let COL_VIEW_BOTTOM_INSET = 0
    let COL_VIEW_LEFT_INSET = 20
    let COL_VIEW_RIGHT_INSET = 20
    let COL_VIEW_CELL_SIZE = 90
    
    // UI Elements Added via Storyboard
    @IBOutlet var scanSwitch : UISwitch!
    @IBOutlet var ticketNumberLabel :UILabel!
    @IBOutlet var collectionView : UICollectionView!

    // Modifiable Class Elements
    var ticketNumber : UInt32 = 0
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
    
    func refreshUI(){
        ticketNumberLabel.text = "Ticker number: \(ticketNumber)"
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
        var current : CollectionViewCell
        current = collectionView.cellForItemAtIndexPath(indexPath)! as CollectionViewCell
        println("Selected: \(current.ticketNumber)");
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

    //// CBPeripheralDelegate Functions
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            peripheral.discoverCharacteristics([TM_USHER_CLIENT_COMMS_CHARACTERIC_TICKET], forService: service as CBService)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        for characteristic in service.characteristics {
            peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!){
        if characteristic.properties == CBCharacteristicProperties.Read {
            self.ticketNumber = dataToInt(characteristic.value)
            refreshUI()
        }
    }
    
}

