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
        self.ticketNumber = 99
        super.init(coder: aDecoder)
    }

    let textLabel: UILabel!
    let imageView: UIImageView!

    var ticketNumber : Int
    var peripheral : CBPeripheral?

    override init(frame: CGRect) {
        self.peripheral = nil
        self.ticketNumber = 99
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 16, width: frame.size.width, height: frame.size.height*2/3))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        
        let textFrame = CGRect(x: 0, y: 32, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)

    }
}
