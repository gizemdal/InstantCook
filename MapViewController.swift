//
//  MapViewController.swift
//  InstantCook
//
//  Created by Gizem Dal on 4/4/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    var span: MKCoordinateSpan = MKCoordinateSpan()
    var firstTime = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (!self.firstTime) {
            if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                let location = locations[0]
                print(location)
                let searchRequest = MKLocalSearchRequest()
                searchRequest.naturalLanguageQuery = "supermarket"
                searchRequest.region = MKCoordinateRegionMake((location.coordinate), MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                print(searchRequest.region)
                let activeSearch = MKLocalSearch(request: searchRequest)
                activeSearch.start { (response, err) in
                    if response == nil{
                        print("Error")
                    }
                    else {
                        // Remove annotations
                        let annotations = self.map.annotations
                        self.map.removeAnnotations(annotations)
                        for items in (response?.mapItems)! {
                            //Getting data
                            let latitude = items.placemark.coordinate.latitude
                            let longitude = items.placemark.coordinate.longitude
                            //Create annotations
                            let annotation = MKPointAnnotation()
                            annotation.coordinate.latitude = latitude
                            annotation.coordinate.longitude = longitude
                            annotation.title = items.name
                            let street = items.placemark.thoroughfare
                            let city = items.placemark.locality
                            let state = items.placemark.administrativeArea
                            let postal = items.placemark.postalCode
                            let country = items.placemark.countryCode
                            annotation.subtitle = "\(street!), \(city!), \(state!), \(postal!), \(country!)"
                            self.map.addAnnotation(annotation)
                        }
                    }
                }
                
            } else {
                //ADD ALERT
            }
        }
        self.firstTime = true
        self.map.showsUserLocation = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.delegate = self
        map.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            
            let location = manager.location
            let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
            span = MKCoordinateSpanMake(0.05, 0.05)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            map.setRegion(region, animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.title! == "Current Location" || annotation.title! == "My Location") {
            return nil
        }
        let supermarketPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        supermarketPin.pinTintColor = UIColor.brown
        supermarketPin.canShowCallout = true
        supermarketPin.isEnabled = true
        supermarketPin.animatesDrop = true
        return supermarketPin
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
