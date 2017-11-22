//
//  HomeViewController.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/20/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    var stack: CoreDataStack!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getCoreDataStack()
        checkVenues()
        checkLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set button attributes
        setViewAttributes()
        setButtonAttributes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startActivityIndicator()
        createFavoritesListIfDoesNotExist()
        stopActivityIndicator()
        listtest()
        
    }
    
    func listtest() {
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                let count = searchResults.count
                print("There are \(count) lists.")
                for searchResult in searchResults {
                    print("Name: \(searchResult.name!)")
                }
            } catch {
                print("There was a problem fetching favorites list")
            }
        })
    }
    
    func startActivityIndicator() {
        performUIUpdatesOnMain(updates: {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        })
    }
    
    func stopActivityIndicator() {
        performUIUpdatesOnMain(updates: {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        })
    }
    
    func getCoreDataStack() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
    }
    
    func createFavoritesListIfDoesNotExist() {
        if (!doesFavoritesListExist()) {
            createFavoritesList()
        }
    }
    
    // sets view attributes
    func setViewAttributes() {
        view.backgroundColor = Style.Color.Primary
        activityIndicator.color = UIColor.green
    }
    
    // sets button background color, text color
    func setButtonAttributes() {
        // search button attributes
        searchButton.backgroundColor = Style.Color.Secondary
        searchButton.setTitleColor(Style.Color.ButtonText, for: .normal)
        searchButton.layer.cornerRadius = Style.Button.cornerRadius
        
        // favortes button attributes
        favoritesButton.backgroundColor = Style.Color.Secondary
        favoritesButton.setTitleColor(Style.Color.ButtonText, for: .normal)
        favoritesButton.layer.cornerRadius = Style.Button.cornerRadius
    }
    
    // create a favorites list
    func createFavoritesList() {
        self.stack.mainContext.performAndWait( {
        
            let entity = NSEntityDescription.entity(forEntityName: "List", in: self.stack.mainContext)
            let list = NSManagedObject(entity: entity!, insertInto: self.stack.mainContext) as? List
            list?.setValue(Style.ListName.favorite, forKey: "name")
            
            print("Favorites list created")
            do {
                try stack.save()
                print("List saved.")
            } catch {
                print("There was a problem saving!")
            }
        })
    }
    
    // navigates to the search view controller
    func navigateToSearchViewController() {
        let nextController = self.storyboard?.instantiateViewController(withIdentifier: Style.ControllerNames.searchViewController) as! SearchViewController
        performUIUpdatesOnMain( updates: {
            self.navigationController?.pushViewController(nextController, animated: true)
        })
    }
    
    // navigates to the favorites table view controller
    func navigateToFavoritesViewController() {
        let nextController = self.storyboard?.instantiateViewController(withIdentifier: Style.ControllerNames.favoritesViewController) as! FavoritesTableViewController
        performUIUpdatesOnMain( updates: {
            self.navigationController?.pushViewController(nextController, animated: true)
        })
    }
    
    // action when favorites button is clicked
    @IBAction func favoritesAction(_ sender: UIButton) {
        navigateToFavoritesViewController()
    }
    
    // action when search button is clicked
    @IBAction func searchAction(_ sender: UIButton) {
        navigateToSearchViewController()
    }
    
    // check to see if Favorites List exists and returns true or false
    func doesFavoritesListExist() -> Bool {
        
        var exists: Bool = false
        
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", Style.ListName.favorite)
            
            fetchRequest.predicate = predicate
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                
                if searchResults.count == 1 {
                    exists = true
                    print("Favorites list already exists!")
                } else {
                    exists = false
                    print("Favorites list does not exist!")
                }
            } catch {
                print("There was a problem fetching favorites list")
            }
        })
        return exists
    }
    
    func checkVenues() {
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                
                print("There are \(searchResults.count) venues.")
            } catch {
                print("There was a problem fetching favorites list")
            }
        })
    }
    
    func checkLocations() {
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                
                print("There are \(searchResults.count) locations.")
            } catch {
                print("There was a problem fetching favorites list")
            }
        })
    }
}
