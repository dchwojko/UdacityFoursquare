//
//  DetailViewController.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/18/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class DetailViewController: UIViewController {

    var venue: Venue!
    var stack: CoreDataStack!
    var bFavorite: Bool!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var urlButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCoreDataStack()
        
        // Configure view
        self.view.backgroundColor = Style.Color.Primary
        
        // Configure buttons
        addressButton.backgroundColor = Style.Color.Secondary
        addressButton.setTitleColor(Style.Color.ButtonText, for: .normal)
        addressButton.layer.cornerRadius = Style.Button.cornerRadius
        phoneButton.backgroundColor = Style.Color.Secondary
        phoneButton.setTitleColor(Style.Color.ButtonText, for: .normal)
        phoneButton.layer.cornerRadius = Style.Button.cornerRadius
        urlButton.backgroundColor = Style.Color.Secondary
        urlButton.setTitleColor(Style.Color.ButtonText, for: .normal)
        urlButton.layer.cornerRadius = Style.Button.cornerRadius
    }
    
    // get core data stack
    func getCoreDataStack() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
    }
    
    // set navigation controller title to name of venue
    func setNavigationControllerTitle() {
        self.title = venue.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationControllerTitle()
        
        bFavorite = venue.isFavorite
        
        // guard against nil longitude and nil latitude
        if (venue.location?.longitude != nil && venue.location?.latitude != nil) {
            
            // set mapview region
            let longitudeSpan = CLLocationDegrees(0.05)
            let latitudeSpan = CLLocationDegrees(0.05)
            
            mapView.region.span = MKCoordinateSpan(latitudeDelta: latitudeSpan, longitudeDelta: longitudeSpan)
            mapView.region.center = CLLocationCoordinate2D(latitude: (venue.location?.latitude)!, longitude: (venue.location?.longitude)!)
            
            // drop pin
            dropPin(longitude: (venue.location?.longitude)!, latitude: (venue.location?.latitude)!)
        } else {
            print("There were no coordinates for venue!")
        }
        
        // build address
        if let address = venue.location?.address, let city = venue.location?.city, let state = venue.location?.state {
            self.addressButton.setTitle("\(address) \(city), \(state)", for: .normal)
        }
        
        // set phone button if exists, otherwise disable
        if let phone = venue.phone {
            phoneButton.setTitle("Call: \(phone)", for: .normal)
        } else {
            phoneButton.isEnabled = false
        }
        
        // set url button if exists, otherwise disable
        if (venue.url != nil && venue.url != "") {
            urlButton.setTitle("Open in Safari", for: .normal)
        } else {
            urlButton.setTitle("No website available", for: .disabled)
            urlButton.isEnabled = false
        }
        
        // update favorites button, red = favorite, black = not favorite
        setFavoriteColor(bFavorite: self.venue.isFavorite)
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        // update favorite
        bFavorite == true ? unmakeFavorite() : makeFavorite()
        self.bFavorite = !(self.bFavorite)
        setFavoriteColor(bFavorite: self.bFavorite)
        
    }
    
    func makeFavorite() {
        self.venue.isFavorite = true
        
        stack.mainContext.performAndWait( {
            
            let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", Style.ListName.favorite)
            
            fetchRequest.predicate = predicate
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                
                if searchResults.count == 1 {
                    
                    //searchResults[0].addToVenues(self.venue)
                    let favoriteList = searchResults[0]                    
                    favoriteList.addToVenues(self.venue)

                    print("There are now \(searchResults[0].venues?.count) venues in the Favorites list")
                    try stack.mainContext.save()
                    print("Added venue to favorite list.")
                } else {
                    print("Favorites list does not exist!")
                }
            } catch {
                print("There was a problem fetching favorites list or saving.")
            }
        })
    }
    
    func unmakeFavorite() {
        self.venue.isFavorite = false
        stack.mainContext.performAndWait({
            let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", Style.ListName.favorite)
            
            fetchRequest.predicate = predicate
            
            do {
                let searchResults = try self.stack.mainContext.fetch(fetchRequest)
                
                if searchResults.count == 1 {
                    searchResults[0].removeFromVenues(self.venue)
                    print("There are now \(searchResults[0].venues?.count) venues in the Favorites list")
                } else {
                    print("Favorites list does not exist!")
                }
            } catch {
                print("There was a problem fetching favorite list")
            }
            
            do {
                print("Saving")
                try stack.mainContext.save()
            } catch {
                print("There was a problem saving Favorites list!")
            }
        })
    }
    
    func setFavoriteColor(bFavorite: Bool) {
        if bFavorite {
            self.favoriteButton.tintColor = Style.Color.Favorite
        } else {
            self.favoriteButton.tintColor = Style.Color.Unfavorite
        }
    }
    
    // make phone call when phone button is clicked
    @IBAction func makePhoneCall(_ sender: Any) {
        
        // strip phone number of unwanted characters (i.e. (, ),
        var phoneNumber: String = (self.phoneButton.titleLabel?.text)!
        
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "+", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        let url = URL(string: "tel://\(phoneNumber)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    // open up safari with url when url button is clicked
    @IBAction func urlAction(_ sender: UIButton) {
        //UIApplication.sharedApplication().openURL(NSURL(string
        let url = NSURL(string: self.venue.url!)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func addressAction(_ sender: UIButton) {
        let latitude: CLLocationDegrees = (venue.location?.latitude)!
        let longitude: CLLocationDegrees = (venue.location?.longitude)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue.name
        mapItem.openInMaps(launchOptions: options)
    }
    
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier: String = Style.ReuseIdentifier.pin
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            
            dequeuedView.annotation = annotation
            view = dequeuedView
            
        } else {
            
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
            view.animatesDrop = true
            view.isDraggable = false
            view.pinTintColor = Style.Color.Pin
        }
        return view
    }
    
    // drop pin on map for given coordinates
    func dropPin(longitude: Double, latitude: Double) {
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate.longitude = longitude
        annotation.coordinate.latitude = latitude
        
        mapView.addAnnotation(annotation)
    }
}
