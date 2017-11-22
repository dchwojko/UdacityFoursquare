Application Name: UdacityFoursquare
Author: Don Chwojko
Date: November 18, 2017

Description:
	This is a simple application that uses the Foursquare API (https://developer.foursquare.com/places-api) to search for venues given a category (i.e food, fitness, etc.) and location (i.e. zip code, city, address) within a specified radius.

CONFIGURATION
- Target Deployment: iOS 11.0
- Devices: Universal
- XCode Version: 9.1


HOME VIEW CONTROLLER
The initial view is the Home View Controller. Here the user can choose either 1) searching for venues or 2) look at the list of favorite venues

SEARCH VIEW CONTROLLER
If the user clicks the Search button in the Home View Controller, the user will be taken to the Search View Controller. Here, the user can specify the category (i.e. food, restaurant, fitness, etc.) of a venue, the location (i.e. zip code, city, address, etc.) and radius (in miles). Clicking the Search button will call the Foursquare API and get a list of venues. If the list is greater than 0, then the user will be taken to the Tab Bar Controller which has a table view of the returned venues and map view of the returned venues.

SEARCH RESULTS TABLE VIEW CONTROLLER
This table view controller will display a list of venues found from the Foursquare API call. Clicking on a table row will take the user to the details view controller for that venue.

SEARCH RESULTS MAP VIEW CONTROLLER
This map view controller will display a list of venues found from the Foursquare API call. Clicking on a pin will take the user to the details view controller for that venue.

DETAILS VIEW CONTROLLER
The details view controller will show a map with the venue location pin, the address, phone number and url. If the phone number / url items are not available, then they will be disabled, otherwise the user will be able to call the venue / open the venue's url. 

The user can also make favorite or unmake favorite the venue. If the user makes the venue a favorite, then the venue will be added to the Favorites List, which is accessible from the Home View Controller. Red Heart = Favorite, Black Heart = Not Favorite

FAVORITES TABLE VIEW CONTROLLER
Accessible from the Home View Controller, the user can click the Favorites button and view the list of favorite venues in a Favorites Table View Controller. Clicking a table row will take the user to the details view controller.
