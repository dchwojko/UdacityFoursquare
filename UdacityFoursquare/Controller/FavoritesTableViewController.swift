//
//  FavoritesTableViewController.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/26/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    var stack: CoreDataStack!
    var venues = [Venue]()
    let reuseIdentifier = Style.ReuseIdentifier.tableCell
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCoreDataStack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreFavorites()
        performUIUpdatesOnMain(updates: {
            self.tableView.reloadData()
        })
    }
    
    func getCoreDataStack() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
    }

    @IBAction func refreshAction(_ sender: Any) {
        performUIUpdatesOnMain(updates: {
            self.tableView.reloadData()
        })
    }
    
    @IBAction func deleteAllAction(_ sender: UIBarButtonItem) {       
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", Style.ListName.favorite)
            
            fetchRequest.predicate = predicate
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                
                if searchResults.count == 1 {
                    for venue in self.venues {
                        self.stack.mainContext.delete(venue)
                        
                    }
                } else {
                    print("Favorites list does not exist!")
                }
            } catch {
                print("There was a problem fetching favorites list")
            }
            do {
                try self.stack.save()
            } catch {
                print("There was a proble saving.")
            }
        })
        
        performUIUpdatesOnMain(updates: {
            self.tableView.reloadData()
        })
    }
    
    // set list of favorite venues
    func restoreFavorites() {
        venues = getFavorites()
    }
    
    // fetch favorite venues
    func getFavorites() -> [Venue] {
        var venues = [Venue]()
        
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
            
            let predicate = NSPredicate(format: "name == %@", Style.ListName.favorite)
            
            fetchRequest.predicate = predicate
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                print("List name: \(searchResults[0].name)")
                let myset = searchResults[0].venues
                let setsize = myset?.count
                venues = searchResults[0].venues?.allObjects as! [Venue]
                print("There are \(venues.count) venues in the Favorites list.")
            } catch {
                print("There was a problem fetching venues")
            }
        })
        return venues
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = venues[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: Style.ControllerNames.detailViewController) as! DetailViewController
        detailViewController.venue = venues[indexPath.row]
        performUIUpdatesOnMain(
            updates: {
                self.navigationController?.pushViewController(detailViewController, animated: true)
        }
        )
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            deleteVenueFromCoreData(venue: venues[indexPath.row])
            performUIUpdatesOnMain(updates: {
                self.venues.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
        }
    }

    func deleteVenueFromCoreData(venue: Venue) {
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", Style.ListName.favorite)
            
            fetchRequest.predicate = predicate
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                
                if searchResults.count == 1 {
                    self.stack.mainContext.delete(venue)

                } else {
                    print("Favorites list does not exist!")
                }
            } catch {
                print("There was a problem fetching favorites list")
            }
            do {
                try self.stack.save()
            } catch {
                print("There was a proble saving.")
            }
        })
    }

}
