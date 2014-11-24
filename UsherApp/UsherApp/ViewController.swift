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
    
    var ticketNumber : UInt32 = 0
    var centralManager : CBCentralManager!
    var peripheralUser : CBPeripheral!
    
    @IBOutlet var scanSwitch : UISwitch!
    @IBOutlet var ticketNumberLabel :UILabel!
    @IBOutlet var collectionView : UICollectionView!
    
    //// UI Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue:nil)
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 250, left: 20, bottom: 150, right: 20)
        layout.itemSize = CGSize(width: 90, height: 90)
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
    
    @IBAction func tapView(sender : AnyObject){
    }
    
    func refreshUI(){
        ticketNumberLabel.text = "Ticker number: \(ticketNumber)"
    }
    
    //// Colection View Delegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
        cell.imageView?.image = UIImage(named: "circle")
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
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
            self.ticketNumber = dataToInt(characteristic.value)
            refreshUI()
        }
    }
    
}

