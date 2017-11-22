//
//  Style.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/18/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    struct Color {
        static var Primary = UIColor.gray
        static var Secondary = UIColor.blue
        static var Tertiary = UIColor.black
        static var ButtonText = UIColor.white
        static var Pin = UIColor.orange
        static var Favorite = UIColor.red
        static var Unfavorite = UIColor.black
    }
    
    struct Button {
        static var cornerRadius: CGFloat = 15.0
    }
    
    struct Stepper {
        static var defaultValue = 2.0
        static var minimumValue = 0.25
        static var maximumValue = 100.0
        static var stepValue = 0.25
    }
    
    struct Font {
        static var Example = UIFont(name: "Helvetica-Bold", size: 20)
    }
    
    struct Title {
        static var venues = "Venues"
    }
    
    struct Keys {
        static var mapLongitude = "mapLongitude"
        static var mapLatitude = "mapLatitude"
        static var location = "location"
        static var category = "category"
        static var radius = "radius"
    }
    
    struct ControllerNames {
        static var detailViewController = "DetailViewController"
        static var searchViewController = "SearchViewController"
        static var favoritesViewController = "FavoritesTableViewController"
        static var tabBarController = "TabBarController"
    }
    
    struct ReuseIdentifier {
        static var tableCell = "Cell"
        static var pin = "Pin"
    }
    
    struct ListName {
        static var favorite = "Favorites"
    }
}
