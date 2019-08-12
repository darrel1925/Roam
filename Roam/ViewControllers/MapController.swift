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
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = UserService.user.locationManager

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // only request to use whe the app is running
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        setUpLocation()
    }
    
    func setUpLocation() {
        print("almost")
        
        print(locationManager.location?.coordinate.longitude ?? 0, locationManager.location?.coordinate.latitude ?? 0)
        
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
        count += 1
        print(manager.location?.coordinate ?? 1, count)
        
        UserService.latitude = (manager.location?.coordinate.latitude)!
        UserService.longitude = (manager.location?.coordinate.longitude)!
        
        let coordinates = CLLocationCoordinate2D(latitude: UserService.latitude, longitude: UserService.longitude)
        
        annotation.coordinate = coordinates
        
        if count >= 15 {
            UserService.sendLocationToFirebase()
            count = 0
        }
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // TODO: DONT FORGET TO STOP LOCATION UPDATING AT SOME POINT
        //locationManager.stopUpdatingLocation()
    }
}
