//
//  MapController.swift
//  Engagingu
//
//  Created by Nicholas on 11/12/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapController: UIViewController {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomlevel: Float = 15.0
    
    override func viewDidLoad() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Creates a GMSCameraPosition that tells the map to display
        // the coordinate -33.86, 151.20, zoom 6.0
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the centre of the map
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){// 5 cases to handle
        case .authorizedAlways, .authorizedWhenInUse: //app can get your location when app is in the background
            //what we want, do map stuff here
            break
            
        case .denied: //dont allow. location needs to be turned on in settings after user clicks deny
            //show alert to guide them on how to turn on permission
            break
            
        case .notDetermined: //user haven't picked allow or dont allow
            //request the permission here
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted: //user cannot change app's status
            // show them alert
            break
        }
    }
}

extension MapController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
}
