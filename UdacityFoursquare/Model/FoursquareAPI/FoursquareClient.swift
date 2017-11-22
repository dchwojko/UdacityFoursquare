//
//  FoursquareClient.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/14/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import Foundation
import CoreData

class FoursquareClient {
    
    var session = URLSession.shared
    var stack: CoreDataStack!
    
    typealias completeClosure = ( _ data: AnyObject?, _ error: Error?)->Void
    
    func taskForGETMethod(url: URL!, callback: @escaping completeClosure) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                callback(nil, NSError(domain: "taskforGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* Guard: was there an error? */
            guard error == nil else {
                sendError(error: "There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* Guard: did we get a successful 2xx response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your request return a status code other than 2xx!")
                return
            }
            
            /* Guard: was there any data return? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                callback(parsedResult as! AnyObject,nil)
            } catch let error as NSError {
                callback(nil, error)
                return
            }
        }
        task.resume()
        return task
    }
    
    /* SINGLETON */
    class func sharedInstance() -> FoursquareClient {
        struct Singleton {
            static var sharedInstance = FoursquareClient()
        }
        return Singleton.sharedInstance
    }
}
