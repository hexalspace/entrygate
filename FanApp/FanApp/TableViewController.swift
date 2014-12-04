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
    
    let numberOfTicketsToDisplay = 1
    
    var possibleTickets = [
        ("CS130 Fall 2014 - C's Get Degrees Tour", "Boelter Dungeon", "12/19/2014", "Section 1, Row 1, Seat 10", "12345"),
        ("David and the Potatoes", "Nowhere, KN", "07/5/2024", "Section 10, Row 100, Seat 2", "54321")
        
    ]
    
    var addedTickets: [CustomTableViewCell] = []
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int)->Int{
        return self.possibleTickets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as CustomTableViewCell
        var(ticket, venue, date, location, id) = self.possibleTickets[indexPath.row]
        cell.loadItem(ticketName: ticket, venueName: venue, eventDate: date, seatLocation: location, ticketID: id)
        addedTickets.append(cell)
        return cell
    }
    
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //println("You selected cell #\(indexPath.row)!")
        //selectedCell =
        //let vs: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController")
        //self.showViewController(vs as UIViewController, sender: vs)
        //performSegueWithIdentifier("toDetailed", sender: self)
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
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfTicketsToDisplay
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
    }
    
}