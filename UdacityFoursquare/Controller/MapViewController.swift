//
//  MapViewController.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/18/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    var venues = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set mapview delegate
        mapView.delegate = self
        
        // get venues from shared tab bar controller
        if let tbc = self.tabBarController as? TabBarController {
            self.venues = tbc.venues
        }
        
        let defaults = UserDefaults.standard
        let latitude = defaults.double(forKey: Style.Keys.mapLatitude)
        let longitude = defaults.double(forKey: Style.Keys.mapLongitude)
        
        // set map view
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: initialLocation)
        
        for venue in venues {
            dropPin(venue: venue)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 10.0, regionRadius * 10.0)
        performUIUpdatesOnMain() {
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performUIUpdatesOnMain(updates: {
            self.tabBarController?.navigationItem.title = Style.Title.venues
        })
    }
}

extension MapViewController: MKMapViewDelegate {
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: Style.ControllerNames.detailViewController) as! DetailViewController
        
        // get venue for selected pin
        if let customAnnotation = view.annotation as? VenuePointAnnotation {
            detailViewController.venue = customAnnotation.venue
        }
        
        // navigate to details view controller
        performUIUpdatesOnMain(
            updates: {
                self.navigationController?.pushViewController(detailViewController, animated: true)
        })
    }
    
    // drop pins on map
    func dropPin(venue: Venue) {
        
        let annotation = VenuePointAnnotation(venue: venue)
        
        annotation.coordinate.longitude = (venue.location?.longitude)!
        annotation.coordinate.latitude = (venue.location?.latitude)!
        
        mapView.addAnnotation(annotation)
    }
}
