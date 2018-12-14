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

class MapController: UIViewController, GMSMapViewDelegate {
    
    var defaultCoordinates = [1,2968, 103.8522]
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var selectedMarker: GMSMarker!
    
    override func viewDidLoad() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? defaultCoordinates[0],
                                              longitude: locationManager.location?.coordinate.longitude ?? defaultCoordinates[1],
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        let hotspots = InstanceDAO.hotspotDict
        
        for (name, hotspot) in hotspots{
            print("name: \(name)")
            
            let coordinates = hotspot.coordinates
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(coordinates[0]) ?? defaultCoordinates[0] , longitude: Double(coordinates[1]) ?? defaultCoordinates[1])
            marker.title = name
            marker.userData = hotspot.narrative
            marker.snippet = "Click me to start mission!"
            marker.map = mapView
            
        }
        
//        // For Testing
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 1.2953, longitude: 103.8506)
//        marker.title = "Placeholder Testing Marker"
//        marker.snippet = "Testing Snippet"
//        marker.map = mapView
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        selectedMarker = marker
        performSegue(withIdentifier: "toNarrativeSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! NarrativeViewController
        
        destVC.headerText = selectedMarker.title!
        destVC.narrativeText = selectedMarker.userData as! String
    }
    
}

extension MapController: CLLocationManagerDelegate{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
