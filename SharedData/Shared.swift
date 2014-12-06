//
//  Shared
//
//  Created by Jacob Jarecki on 11/8/14.
//  Copyright (c) 2014 Jacob Jarecki. All rights reserved.
//

import CoreBluetooth

let TM_USHER_CLIENT_COMMS_SERVICE = CBUUID(string: "BA0A5518-4D18-443A-817F-D726062085BD")
let TM_USHER_CLIENT_COMMS_CHARACTERIC_TICKET = CBUUID(string: "C04761A0-51E9-4653-B51D-FC93C3B691CF")
let TM_USHER_CLIENT_COMMS_CHARACTERIC_STATUS = CBUUID(string: "47F5C171-619F-4B3B-A983-36066CAC1ACC")

let DEBUG = true
let TEST = true

func dataToInt(theData : NSData) -> UInt32 {
    var theInteger : UInt32 = 0
    theData.getBytes(&theInteger, length: sizeof(UInt32))
    return theInteger
}

func intToData(theInteger : UInt32) -> NSData {
    var theIntegerCopy : UInt32 = theInteger
    var theData : NSData = NSData(bytes: &theIntegerCopy, length: sizeof(UInt32))
    return theData
}