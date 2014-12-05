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
        
    }
}


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var selectedCell: CustomTableViewCell = CustomTableViewCell()
    
    var possibleTickets = [
        ("CS130 Fall 2014 - C's Get Degrees Tour", "Boelter Dungeon", "12/19/2014", "Section 1, Row 1, Seat 10", "12345"),
        ("David and the Potatoes", "Nowhere, KN", "07/5/2024", "Section 10, Row 100, Seat 2", "54321"),
        ("You've Probably Never Head of Them Anyway", "Local coffee shop", "12/6/2014", "Sit anywhere", "12985"),
        ("The Artist Formally Known as \'Eggert\'", "Staples Center", "3/3/15", "Section 4, Row 9, Seat 15", "31415"),
        ("UCLA Marching Band with John Wiliams *hint hint*", "Hollywood Bowl", "11/15/15", "Section 9, Row 6, Seat 20", "92129"),
        ("The Nibblers - Keep on Nibbing Tour", "Rose Bowl", "Tomorrow", "Section 6A, Row 1, Seat nib", "82754"),
        ("Rolling Stones - 200 and Counting Tour", "Pauley Space Station Pavillion", "4/18/2163", "Backstage Access", "82653"),
        ("The 100th Turing Awards - Noah Duncan Hosting", "Dolby Theatre", "6/17/2066", "Row 1 Seat 1", "01101")
    ]
    
    var addedTickets: [CustomTableViewCell] = []
    
    let numberOfTicketsToDisplay = 2
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int)->Int{
        return numberOfTicketsToDisplay
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as CustomTableViewCell
        var randomNumber: Int = Int(arc4random_uniform(UInt32(possibleTickets.count)))
        var(ticket, venue, date, location, id) = self.possibleTickets[randomNumber]
        possibleTickets.removeAtIndex(randomNumber)
        cell.loadItem(ticketName: ticket, venueName: venue, eventDate: date, seatLocation: location, ticketID: id)
        addedTickets.append(cell)
        return cell
    }
    
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectedCell = addedTickets[indexPath.row]
        self.performSegueWithIdentifier("TicketSelected", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if(segue.identifier == "TicketSelected"){
            var newView = segue.destinationViewController as SelectedTicketViewController
            newView.ticketName = selectedCell.ticketName.text!
            newView.venue = selectedCell.venueName.text!
            newView.date = selectedCell.eventDate.text!
            newView.seat = selectedCell.seatLocation.text!
            newView.id = selectedCell.ticketID.text!
        }
    }

    @IBAction func helpPressed(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "Help"
        alert.message = "Tap a ticket from the list below to continue"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}