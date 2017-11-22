//
//  List+CoreDataProperties.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 11/8/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var name: String?
    @NSManaged public var venues: NSSet?

}

// MARK: Generated accessors for venues
extension List {

    @objc(addVenuesObject:)
    @NSManaged public func addToVenues(_ value: Venue)

    @objc(removeVenuesObject:)
    @NSManaged public func removeFromVenues(_ value: Venue)

    @objc(addVenues:)
    @NSManaged public func addToVenues(_ values: NSSet)

    @objc(removeVenues:)
    @NSManaged public func removeFromVenues(_ values: NSSet)

}
