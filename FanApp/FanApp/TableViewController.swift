//
//  TableViewController.swift
//  FanApp
//
//  Created by Ryan Dall on 12/3/14.
//  Copyright (c) 2014 TM-UCLA-BLE. All rights reserved.
//

import UIKit

class CustomTableViewCell : UITableViewCell{
    @IBOutlet var ticketName: UILabel!
    @IBOutlet var venueName: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var seatLocation: UILabel!
    @IBOutlet var ticketID: UILabel!
    
    func loadItem(#ticketName: String, venueName: String, eventDate: String, seatLocation: String, ticketID: String){
        self.ticketName.text = ticketName
        self.venueName.text = "Venue: \(venueName)"
        self.eventDate.text = "Date: \(eventDate)"
        self.seatLocation.text = seatLocation
        self.ticketID.text = "Ticket ID: \(ticketID)"
        
        println("Cell loaded")
        
    }
}


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let numberOfTicketsToDisplay = 1
    
    var possibleTickets = [
        ("CS130 Fall 2014 - C's Get Degrees Tour", "Boelter Dungeon", "12/19/2014", "Section 1, Row 1, Seat 10", "12345"),
        ("CS130 Fall 2014 - C's Get Degrees Tour", "Boelter Dungeon", "12/19/2014", "Section 1, Row 1, Seat 10", "12346")
        
    ]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return numberOfTicketsToDisplay
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as CustomTableViewCell
        var (name, venue, date, seat, id) = possibleTickets[indexPath.row]
        cell.loadItem(ticketName: name, venueName: venue, eventDate: date, seatLocation: seat, ticketID: id)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfTicketsToDisplay
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        //self.tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customCell")
    }
    
}