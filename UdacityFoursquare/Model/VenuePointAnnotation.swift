//
//  VenuePointAnnotation.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 11/17/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import Foundation
import MapKit

class VenuePointAnnotation: MKPointAnnotation {
    var venue: Venue!
    
    init(venue: Venue!) {
        self.venue = venue
    }
}
