//
//  CollectionViewCell.swift
//  UsherApp
//
//  Created by Jacob Jarecki on 11/19/14.
//  Copyright (c) 2014 TM-UCLA-BLE. All rights reserved.
//

import UIKit
import CoreBluetooth

class CollectionViewCell: UICollectionViewCell {
    
    required init(coder aDecoder: NSCoder) {
        self.cellIndex = -1
        self.ticketID = ""
        self.eventName = ""
        self.colorID = LIGHT_GRAY_COLOR_ID
        self.peripheral = nil
        self.recievedValidatedColor = false
        self.validationColorCharacteristic = nil
        self.ticketValidatedCharacteristic = nil
        super.init(coder: aDecoder)
    }

    let textLabel: UILabel!

    var cellIndex : Int
    var ticketID : String
    var eventName : String
    var colorID : Int
    var peripheral : CBPeripheral?
    var recievedValidatedColor : Bool
    var validationColorCharacteristic : CBCharacteristic?
    var ticketValidatedCharacteristic : CBCharacteristic?

    override init(frame: CGRect) {
        self.cellIndex = -1
        self.ticketID = ""
        self.eventName = ""
        self.colorID = LIGHT_GRAY_COLOR_ID
        self.peripheral = nil
        self.recievedValidatedColor = false
        self.validationColorCharacteristic = nil
        self.ticketValidatedCharacteristic = nil
        super.init(frame: frame)
        
        let textFrame = CGRect(x: 0, y: 32, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
    }

    func copyCell(adjCell: CollectionViewCell){
        self.cellIndex = adjCell.cellIndex
        self.ticketID = adjCell.ticketID
        self.eventName = adjCell.eventName
        self.peripheral = adjCell.peripheral
        self.backgroundColor = adjCell.backgroundColor
        self.colorID = adjCell.colorID
        self.recievedValidatedColor = adjCell.recievedValidatedColor
    }

    func resetCell(){
        self.cellIndex = -1
        self.ticketID = ""
        self.eventName = ""
        self.colorID = LIGHT_GRAY_COLOR_ID
        self.peripheral = nil
        self.recievedValidatedColor = false
        self.validationColorCharacteristic = nil
        self.ticketValidatedCharacteristic = nil

        self.backgroundColor = UIColor.lightGrayColor()
    }
}
