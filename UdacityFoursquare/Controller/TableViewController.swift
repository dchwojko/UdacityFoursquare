//
//  TableViewController.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/16/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let reuseIdentifier = Style.ReuseIdentifier.tableCell
    
    var location: String?
    var category: String?
    var radius: Double?
    
    var venues = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        performUIUpdatesOnMain(updates: {
            self.tabBarController?.navigationItem.title = Style.Title.venues
        })
        
        // retrieve search criteria
        let defaults = UserDefaults.standard
        self.location = defaults.string(forKey: Style.Keys.location)
        self.category = defaults.string(forKey: Style.Keys.category)
        self.radius = defaults.double(forKey: Style.Keys.radius)
        
        // get venues from shared tab bar controller
        if let tbc = self.tabBarController as? TabBarController {
            // do something with tbc.myInformation
            self.venues = tbc.venues
        }
        
        performUIUpdatesOnMain(updates: {
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row) : " + venues[indexPath.row].name!
        if (venues[indexPath.row].phone != nil) {
            cell.detailTextLabel?.text = venues[indexPath.row].phone
        } else if (venues[indexPath.row].url != nil) {
            cell.detailTextLabel?.text = venues[indexPath.row].url
        } else {
            cell.detailTextLabel?.text = ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: Style.ControllerNames.detailViewController) as! DetailViewController
        detailController.venue = venues[indexPath.row]
        performUIUpdatesOnMain(
            updates: {
                self.navigationController?.pushViewController(detailController, animated: true)
            }
        )
    }
}
