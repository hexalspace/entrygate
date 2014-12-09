//
//  Shared
//
//  Created by Jacob Jarecki on 11/8/14.
//  Copyright (c) 2014 Jacob Jarecki. All rights reserved.
//

import UIKit
import CoreBluetooth

let TM_FAN_CLIENT_COMMS_SERVICE = CBUUID(string: "2DBB2280-ACD5-4FCB-ABE5-A465AA69BACC")
let TM_FAN_CLIENT_EVENT_NAME_CHARACTERISTIC = CBUUID(string: "F300A4A9-C79A-4179-946D-35664899C9FE")
let TM_FAN_CLIENT_TICKET_ID_CHARACTERISTIC = CBUUID(string: "403F0889-5721-4F56-97B6-DF5AD7F47B3B")
let TM_FAN_CLIENT_VALIDATION_COLOR_CHARACTERISTIC = CBUUID(string: "0DDAE2F8-76CB-4281-926D-8CA5C6BB6868")
let TM_FAN_CLIENT_TICKET_VALIDATED_CHARACTERISTIC = CBUUID(string: "7764F603-22C7-4BCD-993D-99EF3B22968B")

let LIGHT_GRAY_COLOR_ID = 9
let colorMapping = [UIColor.redColor(), UIColor.magentaColor(), UIColor.blueColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.blackColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.lightGrayColor()]
let VALIDATE_STRING = "VALIDATED"

let DEBUG = false

func dataToString(theData : NSData) -> String {
    return String(NSString(data: theData, encoding: NSUTF8StringEncoding)!)
}

func stringToData(theString : String) -> NSData {
    return NSString(string: theString).dataUsingEncoding(NSUTF8StringEncoding)!
}

func getColor(stringInt : String) -> UIColor {
	return colorMapping[stringInt.toInt()!]
}

func getColor(theInt : Int) -> UIColor {
	return colorMapping[theInt]
}
