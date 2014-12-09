//
//  FanBluetoothManager.swift
//  FanApp
//
//  Created by Ryan Dall on 12/6/14.
//  Copyright (c) 2014 TM-UCLA-BLE. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore

class FanBluetoothManager: NSObject, CBPeripheralManagerDelegate{
    
    let TM_FAN_CLIENT_COMMS_SERVICE = CBUUID(string: "2DBB2280-ACD5-4FCB-ABE5-A465AA69BACC")
    let TM_FAN_CLIENT_EVENT_NAME_CHARACTERISTIC = CBUUID(string: "F300A4A9-C79A-4179-946D-35664899C9FE")
    let TM_FAN_CLIENT_TICKET_ID_CHARACTERISTIC = CBUUID(string: "403F0889-5721-4F56-97B6-DF5AD7F47B3B")
    let TM_FAN_CLIENT_VALIDATION_COLOR = CBUUID(string: "0DDAE2F8-76CB-4281-926D-8CA5C6BB6868")
    let TM_FAN_CLIENT_TICKET_VALIDATED_CHARACTERISTIC = CBUUID(string: "7764F603-22C7-4BCD-993D-99EF3B22968B")
    
    var viewController : SelectedTicketViewController!
    
    var peripheralManager : CBPeripheralManager!
    var commService : CBMutableService!
    var eventCharacteristic : CBMutableCharacteristic!
    var idCharacteristic : CBMutableCharacteristic!
    var colorCharacteristic : CBMutableCharacteristic!
    var validatedCharacteristic : CBMutableCharacteristic!
    
    
    init(view: SelectedTicketViewController, eventName: String, ticketID: String){
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        viewController = view
        
        eventCharacteristic = CBMutableCharacteristic(type: TM_FAN_CLIENT_EVENT_NAME_CHARACTERISTIC, properties: CBCharacteristicProperties.Read, value: NSData(base64EncodedString: eventName, options: nil), permissions: CBAttributePermissions.Readable)
        
        idCharacteristic = CBMutableCharacteristic(type: TM_FAN_CLIENT_TICKET_ID_CHARACTERISTIC, properties: CBCharacteristicProperties.Read, value: NSData(base64EncodedString: ticketID, options: nil), permissions: CBAttributePermissions.Readable)
        
        colorCharacteristic = CBMutableCharacteristic(type: TM_FAN_CLIENT_VALIDATION_COLOR, properties: CBCharacteristicProperties.Write, value: nil, permissions: CBAttributePermissions.Writeable)
        
        validatedCharacteristic = CBMutableCharacteristic(type: TM_FAN_CLIENT_TICKET_VALIDATED_CHARACTERISTIC, properties: CBCharacteristicProperties.Write, value: nil, permissions: CBAttributePermissions.Writeable)
        
        var characteristics = [eventCharacteristic, idCharacteristic, colorCharacteristic, validatedCharacteristic]
        
        commService = CBMutableService(type: TM_FAN_CLIENT_COMMS_SERVICE, primary: true)
        //commService = CBMutableService(type: CBUUID(string: "2DBB2280-ACD5-4FCB-ABE5-A465AA69BACC"), primary: true)
    
        commService.characteristics = characteristics
        
        peripheralManager.addService(commService)
        //commService.includedServices = [CBMutableService(type: TM_FAN_CLIENT_COMMS_SERVICE, primary: true)]
        
    }
    
    func getValidationColor() -> NSData{
        return colorCharacteristic.value
    }
    
    func getValidationStatus() -> NSData{
        return validatedCharacteristic.value
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, didAddService service: CBService!, error: NSError!) {
        println("YO! + \(error)")
    }
    
    func startAdvertising(){
        switch peripheralManager.state{
        case .PoweredOn:
            println("Service is \([CBAdvertisementDataServiceDataKey:TM_FAN_CLIENT_COMMS_SERVICE])")
            peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey:"Fan APP", CBAdvertisementDataServiceUUIDsKey:[TM_FAN_CLIENT_COMMS_SERVICE]])
            break
        default:
            println("Can't begin advertising when bluetooth is not enabled")
            break
            
        }

    }
    
    func stopAdvertising(){
        peripheralManager.stopAdvertising()
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveReadRequest request: CBATTRequest!) {
        switch request.characteristic.UUID{
        case TM_FAN_CLIENT_EVENT_NAME_CHARACTERISTIC:
            request.value = eventCharacteristic.value
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
            println("Received read request")
            break
        case TM_FAN_CLIENT_TICKET_ID_CHARACTERISTIC:
            request.value = idCharacteristic.value
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
            println("Received read request")
            break
        case TM_FAN_CLIENT_VALIDATION_COLOR:
            request.value = colorCharacteristic.value
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
            break
        case TM_FAN_CLIENT_TICKET_VALIDATED_CHARACTERISTIC:
            request.value = validatedCharacteristic.value
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
            break
        default:
            peripheral.respondToRequest(request, withResult: CBATTError.RequestNotSupported)
            break
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveWriteRequests requests: [AnyObject]!) {
        for request in requests{
            var downcastRequest = request as CBATTRequest
            switch request.UUID{
            case TM_FAN_CLIENT_EVENT_NAME_CHARACTERISTIC:
                peripheral.respondToRequest(downcastRequest, withResult: CBATTError.WriteNotPermitted)
                break
            case TM_FAN_CLIENT_TICKET_ID_CHARACTERISTIC:
                peripheral.respondToRequest(downcastRequest, withResult: CBATTError.WriteNotPermitted)
                break
            case TM_FAN_CLIENT_VALIDATION_COLOR:
                colorCharacteristic.value = downcastRequest.value
                peripheral.respondToRequest(downcastRequest, withResult: CBATTError.Success)
                viewController.sucessfulConnection()
                break
            case TM_FAN_CLIENT_TICKET_VALIDATED_CHARACTERISTIC:
                validatedCharacteristic.value = downcastRequest.value
                peripheral.respondToRequest(downcastRequest, withResult: CBATTError.Success)
                viewController.ticketValidated()
                break
            default:
                peripheral.respondToRequest(downcastRequest, withResult: CBATTError.RequestNotSupported)
                break
            }

        }
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        switch peripheralManager.state
        {
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
    
}
