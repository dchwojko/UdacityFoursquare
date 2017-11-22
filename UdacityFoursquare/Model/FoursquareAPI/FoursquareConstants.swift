//
//  FoursquareConstants.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/14/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import Foundation

extension FoursquareClient {
    struct CONSTANTS {
        static let ApiScheme = "https"
        static let ApiHost = "api.foursquare.com"
        static let ApiPath = "/v2/venues/search"
        static let ClientID = "YFEKHVIORVAQLOU2PKY4E4TQUIWTGUCMPQF42CIAOBSSZQZS"
        static let ClientSecret = "3LIC5LCO42N2T0EU4MGNOVE2XFRC5L4KHOT5N3UV111DIYIZ"
    }
    
    struct PARAMETERKEYS {
        static let VERSION = "v"
        static let CLIENTID = "client_id"
        static let CLIENTSECRET = "client_secret"
        static let NEAR = "near"
        static let CATEGORIES = "query"
        static let RADIUS = "radius"
    }
    
    struct METHODS {
        
    }
}

//https://api.foursquare.com/v2/venues/search?near=Elmhurst,IL& &v=20170101
