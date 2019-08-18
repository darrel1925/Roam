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
import FirebaseFirestore

class MapController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = LocationService.locationManager
    var region: MKCoordinateRegion!
    var annotation: MKPointAnnotation = MKPointAnnotation()
    var count = 0
    
    var roamerLatitude: CLLocationDegrees!
    var roamerLongitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setUpLocation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func setUpLocation() {
        // only request to use when the app is running
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
        print("co are",longitude, latitude)
        map.setRegion(self.region, animated: true)
        
        map.showsBuildings = true
        map.showsUserLocation = true
        map.showsCompass = true
//        annotation = MKPointAnnotation()
//
//        annotation.coordinate = coordinates
//
//        map.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        count += 1
        print(manager.location?.coordinate ?? 1, count)
        
        let latitude = (manager.location?.coordinate.latitude)!
        let longitude = (manager.location?.coordinate.longitude)!
        LocationService.updateLocationWith(latitude: latitude, longitude: longitude)

//        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//        annotation.coordinate = coordinates
        
        if count >= 5 {
            LocationService.sendLocationToFirebaseAsCustomer()
            getRoamerLocationFromFireBase()
            count = 0
        }
    }
    
    func getRoamerLocationFromFireBase() {
        let db = Firestore.firestore()
        let docRef = db.collection("ActiveRoamers").document("a@gmail.com")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.roamerLatitude = document["customerLatitude"] as? CLLocationDegrees ?? 5
                self.roamerLongitude = document["customerLongitude"] as? CLLocationDegrees ?? 5
                self.updatePositionOnMap()
                
                print(self.roamerLatitude, self.roamerLongitude)
            } else {
                self.displayError(title: "Error", message: "Could not get customer location from server")
            }
        }
    }
    
    func updatePositionOnMap() {
        let coordinates = CLLocationCoordinate2D(latitude: self.roamerLatitude, longitude: self.roamerLongitude)
        if (map.annotations.count > 0) { map.removeAnnotation(annotation) }
        
        annotation.coordinate = coordinates
        annotation.title = "Romaers Location"
        
        map.addAnnotation(annotation)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // TODO: DONT FORGET TO STOP LOCATION UPDATING AT SOME POINT
        //locationManager.stopUpdatingLocation()
    }
}

extension MapController: CLLocationManagerDelegate {
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            setUpLocation()
            print("location when in use")
            break
        case .denied:
            // show alert telling them how to turn on permissions
            break
        case .notDetermined:
            // when we request the permission for first time
            locationManager.requestAlwaysAuthorization()
            break
        case .restricted:
            // parental control restriction
            // let them know how to disable it
            break
        case .authorizedAlways:
            // do map stuff
            setUpLocation()
            print("location always")
            break
        @unknown default:
            break
        }
    }
    
    func checkLocationServices() {
        // if location is enabled device wide
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert telling user they have to turn this on.
        }
    }
    
}

