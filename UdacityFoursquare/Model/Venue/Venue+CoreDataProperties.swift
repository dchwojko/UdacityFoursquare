//
//  Venue+CoreDataProperties.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 11/8/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//
//

import Foundation
import CoreData


extension Venue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Venue> {
        return NSFetchRequest<Venue>(entityName: "Venue")
    }

    @NSManaged public var id: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var url: String?
    @NSManaged public var location: Location?
    @NSManaged public var list: List?

}
