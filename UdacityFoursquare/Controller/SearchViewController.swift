//
//  SearchViewController.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/16/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class SearchViewController: UIViewController, UITextFieldDelegate {

    var stack: CoreDataStack!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var CategoryTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var radiusStepper: UIStepper!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let metersPerMile: Double = 1609.34
    let limit = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewAttributes()
        getCoreDataStack()
    }

    func getCoreDataStack() {
        // get core data stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
    }
    
    func setViewAttributes() {
        radiusStepper.value = Style.Stepper.defaultValue
        radiusStepper.minimumValue = Style.Stepper.minimumValue
        radiusStepper.maximumValue = Style.Stepper.maximumValue
        radiusStepper.stepValue = Style.Stepper.stepValue
        searchButton.layer.cornerRadius = Style.Button.cornerRadius
        radiusTextField.isEnabled = false
        view.backgroundColor = Style.Color.Primary
        searchButton.backgroundColor = Style.Color.Secondary
    }
    
    // returns appropriate units (mile or miles)
    func getUnitLabel(distance: Double) -> String {
        if distance == 1.0 {
            return "mile"
        } else {
            return "miles"
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        stopActivityIndicator()
        
        // set radius text field
        radiusTextField.text = "\(radiusStepper.value) \(getUnitLabel(distance: radiusStepper.value))"
        
        // subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        
        // set textfield delegates
        locationTextField.delegate = self
        CategoryTextField.delegate = self
        radiusTextField.delegate = self
        
    }
    
    // hide and stop activity indicator
    func stopActivityIndicator() {
        performUIUpdatesOnMain(updates: {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        })
    }
    
    // show and start activity indicator
    func startActivityIndicator() {
        performUIUpdatesOnMain(updates: {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        })
    }
    
    // gets coordinates for a given address
    func forwardGeocoding(address: String, completionHandler: @escaping (CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                completionHandler(coordinate)
            }
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe to keyboard notifications
        unsubscribeToKeyboardNotifications()
    }
    
    // updates radius text field on stepper action
    @IBAction func stepperAction(_ sender: UIStepper) {
        radiusTextField.text = "\(radiusStepper.value) \(getUnitLabel(distance: radiusStepper.value))"
    }
    
    // perform search
    // if location text field is nil, throw alert
    // if no results are return, throw alert
    @IBAction func searchAction(_ sender: UIButton) {
        
        // guard against nil or "" location text field strings
        guard locationTextField.text != nil && locationTextField.text != "" else {
            view.endEditing(true)
            let alert = UIAlertController(title: "Erorr", message: "You must enter a location!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // END EDITING - HIDING KEYBOARD
        view.endEditing(true)
        
        let defaults = UserDefaults.standard
        
        // convert from miles to meters
        let meters = metersPerMile * radiusStepper.value
        
        // save search query to nsuserdefaults
        defaults.set(meters, forKey: "radius")
        defaults.set(locationTextField.text, forKey: Style.Keys.location)
        defaults.set(CategoryTextField.text, forKey: Style.Keys.category)
        
        // get coordinates for location, save to nsuserdefaults
        _ = self.forwardGeocoding(address: locationTextField.text!){ (coordinate) in
            guard coordinate != nil else {
                print("no coordinates")
                return
            }
            defaults.set(coordinate?.latitude, forKey: Style.Keys.mapLatitude)
            defaults.set(coordinate?.longitude, forKey: Style.Keys.mapLongitude)
        }
        
        startActivityIndicator()
        
        // search via Foursquare API
        FoursquareClient.sharedInstance().searchNear(location: "\(self.locationTextField.text!)", categories: "\(self.CategoryTextField.text!)", radius: meters, context: stack.mainContext) { (error, venues) in
            
            self.stopActivityIndicator()
            
            guard error == nil else {
                var message = "There was an unknown error."
                if (error?.localizedDescription.contains("The Internet connection appears to be offline."))! {
                    message = "The Internet connection appears to be offline."
                }
                
                let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                performUIUpdatesOnMain( updates: {
                    self.present(alert, animated: true, completion: nil)
                })
                return
            }
            
            // if 1 or more venues are returned proceed, otherwise alert user there was a problem
            if (venues.count > 0) {
                // Instantiate custom TabBarController
                let nextController = self.storyboard?.instantiateViewController(withIdentifier: Style.ControllerNames.tabBarController) as! TabBarController
                nextController.venues = venues
            
                performUIUpdatesOnMain( updates: {
                    self.stopActivityIndicator()
                    self.navigationController?.pushViewController(nextController, animated: true)
                })
            } else {
                let alert = UIAlertController(title: "Warning", message: "No venues were found for your parameters.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                performUIUpdatesOnMain( updates: {
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y += getKeyboardHeight(notification: notification)
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
}
