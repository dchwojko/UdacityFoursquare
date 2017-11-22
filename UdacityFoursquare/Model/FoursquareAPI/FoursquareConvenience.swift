//
//  FoursquareConvenience.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/15/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import Foundation
import CoreData

extension FoursquareClient {
    func searchNear(location: String, categories: String?, radius: Double?,  context: NSManagedObjectContext, completionHandler: @escaping (_ error: Error?, _ venues: [Venue]) -> Void) {
        var components = URLComponents()
        components.scheme = FoursquareClient.CONSTANTS.ApiScheme
        components.host = FoursquareClient.CONSTANTS.ApiHost
        components.path = FoursquareClient.CONSTANTS.ApiPath
        let queryItem1 = URLQueryItem(name: FoursquareClient.PARAMETERKEYS.CLIENTID, value: FoursquareClient.CONSTANTS.ClientID)
        let queryItem2 = URLQueryItem(name: FoursquareClient.PARAMETERKEYS.CLIENTSECRET, value: FoursquareClient.CONSTANTS.ClientSecret)
        let queryItem3 = URLQueryItem(name: FoursquareClient.PARAMETERKEYS.VERSION, value: "20170101")
        let queryItem4 = URLQueryItem(name: FoursquareClient.PARAMETERKEYS.NEAR, value: location)
        let queryItem5 = URLQueryItem(name: FoursquareClient.PARAMETERKEYS.CATEGORIES, value: categories)
        let queryItem6 = URLQueryItem(name: FoursquareClient.PARAMETERKEYS.RADIUS, value: "\(radius!)")
        components.queryItems = [queryItem1, queryItem2, queryItem3, queryItem4, queryItem5, queryItem6]
        print(components.url!)
        
        FoursquareClient.sharedInstance().taskForGETMethod(url: components.url) { (data,error) in
            guard error == nil else {
                print(error)
                completionHandler(error, [Venue]())
                return
            }
            
            guard data != nil else {
                fatalError("data was nil")
            }
            
            print(data!)
            let venues = self.parseVenuesData(data: data, context: context)
            completionHandler(nil, venues)
            return
        }
    }
    
    func parseVenuesData(data: AnyObject!, context: NSManagedObjectContext) -> [Venue] {
        var retrievedVenues = [Venue]()
        guard data != nil else {
            fatalError("data is nil")
        }
        
        if let meta = data["meta"]! as? [String:Any] {
            if let statusCode = meta["code"]! as? Int {
                print("Code: \(statusCode)")
            }
            if let requestId = meta["requestId"]! as? String {
                print("Request ID: \(requestId)")
            }
        }
        
        if let response = data["response"]! as? [String:Any] {
            if let venues = response["venues"]! as? [[String:Any]] {
                for venue in venues {
                    if let id = venue["id"]! as? String, let name = venue["name"]! as? String {
                        let url = venue["url"] as? String
                        let contact = venue["contact"]! as? [String:String]
                        let phone = contact!["formattedPhone"]

                        // GET LOCATION DETAILS
                        
                        var address1: String?
                        var city1: String?
                        var country1: String?
                        var latitude1: Double = 0
                        var longitude1: Double = 0
                        var postalCode1: Int16 = 0
                        var state1: String?
                        
                        if let location = venue["location"]! as? [String:Any] {
                        
                            if let address = location["address"] as? String {
                                address1 = address
                            }
                            if let city = location["city"] as? String {
                                city1 = city
                            }
                            if let country = location["country"] as? String {
                                country1 = country
                            }
                            if let latitude = location["lat"] as? Double {
                                latitude1 = latitude
                            }
                            if let longitude = location["lng"] as? Double {
                                longitude1 = longitude
                            }
                            if let postalCode = location["postalCode"] as? Int16 {
                                postalCode1 = Int16(postalCode)
                            }
                            if let state = location["state"] as? String {
                                state1 = state
                            }
                        }
                        
                        let theLocation = createLocation(address: address1, city: city1, country: country1, latitude: latitude1, longitude: longitude1, postalCode: postalCode1, state: state1, venue: nil, context: context)
                        
                        let theVenue = createVenue(id: id, isFavorite: false, name: name, phone: phone, url: url, location: theLocation, list: nil, context: context)
 
                        // Append venue to venues array
                        retrievedVenues.append(theVenue)
                    }
                }
            }
        }
        return retrievedVenues
    }
    
    func createLocation(address: String?, city: String?, country: String?, latitude: Double, longitude: Double, postalCode: Int16, state: String?, venue: Venue?, context: NSManagedObjectContext) -> Location {
        var l: Location?
        context.performAndWait({
            
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
            let location = NSManagedObject(entity: entity!, insertInto: context) as? Location
            location?.setValue(address, forKey: "address")
            location?.setValue(city, forKey: "city")
            location?.setValue(country, forKey: "country")
            location?.setValue(latitude, forKey: "latitude")
            location?.setValue(longitude, forKey: "longitude")
            location?.setValue(postalCode, forKey: "postalCode")
            location?.setValue(state, forKey: "state")
            location?.setValue(venue, forKey: "venue")
            do {
                try context.save()
                print("Location saved")
            } catch {
                print("There was a problem saving the location!")
            }
            l = location as! Location
        })
        return l!
    }
    
    func createVenue(id: String?, isFavorite: Bool, name: String?, phone: String?, url: String?, location: Location?, list: List?, context: NSManagedObjectContext) -> Venue {
        var v: Venue?
        context.performAndWait({
            let entity = NSEntityDescription.entity(forEntityName: "Venue", in: context)
            let venue = NSManagedObject(entity: entity!, insertInto: context) as? Venue
            venue?.setValue(id, forKey: "id")
            venue?.setValue(isFavorite, forKey: "isFavorite")
            venue?.setValue(name, forKey: "name")
            venue?.setValue(phone, forKey: "phone")
            venue?.setValue(url, forKey: "url")
            venue?.setValue(location, forKey: "location")
            venue?.setValue(list, forKey: "list")
            do {
                try context.save()
                print("Venue saved")
            } catch {
                print("There was a problem saving the venue!")
            }
            v = venue as! Venue
        })
        return v!
    }
    
    func getVenueDetails(venueId: String!, completionHandler: @escaping (_ venues: [Venue]) -> Void) {
    }
}
