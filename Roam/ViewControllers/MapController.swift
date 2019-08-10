//
//  MapController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/9/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager: CLLocationManager!
    var region: MKCoordinateRegion!
    var annotation: MKPointAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = UserService.getLocation(mapController: self)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // only request to use whe the app is running
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        setUpLocation()
    }
    
    func setUpLocation() {
        print("almost")
        
        print(locationManager.location?.coordinate.longitude, locationManager.location?.coordinate.latitude)
        
        guard let longitude = locationManager.location?.coordinate.longitude,
              let latitude = locationManager.location?.coordinate.latitude
              else {
                self.displayError(title: "Network Error", message: "Unable to determine Location")
                return
            }
        
        print("got location :)")
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // zoom of the map
        let latDelta: CLLocationDegrees = 0.025
        
        let lonDelta: CLLocationDegrees = 0.025
        
        // a combination of latdelta and lon delta to show overall zoom
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        self.region = MKCoordinateRegion(center: coordinates, span: span)
        
        map.setRegion(self.region, animated: true)
        
        annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinates
        
        map.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.coordinate)
        
        let latitude = (manager.location?.coordinate.latitude)!
        let longitude = (manager.location?.coordinate.longitude)!
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        annotation.coordinate = coordinates
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // TODO: DONT FORGET TO STOP LOCATION UPDATING AT SOME POINT
        //locationManager.stopUpdatingLocation()
    }
}
