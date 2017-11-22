//
//  Location+CoreDataProperties.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 11/8/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var postalCode: Int16
    @NSManaged public var state: String?
    @NSManaged public var venue: Venue?

}
