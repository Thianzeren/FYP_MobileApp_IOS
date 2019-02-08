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
    var distanceToTriggier = 5 // In Meteres
    
    override func viewDidLoad() {
        
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
        
        // Refresh hotspots
        initiateHotspots()
        
//        // For Testing
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 1.2953, longitude: 103.8506)
//        marker.title = "Placeholder Testing Marker"
//        marker.snippet = "Testing Snippet"
//        marker.map = mapView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear Map Controller")
        
        initiateHotspots()
        
        // When all trail is finished
        if(InstanceDAO.completedList.count == InstanceDAO.hotspotDict.count){
            
            let alert = UIAlertController(title: "Awesome! You have finished all the hotspots", message: "Head back to the starting location to finish the trail", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        selectedMarker = marker
        
        // to check if user is near the hotspot
        // Get marker's location
        let selectedMarkerLocation = CLLocation(latitude: selectedMarker.position.latitude, longitude: selectedMarker.position.longitude)
        
        // Get distance from current location to selected marker location
        let distance = currentLocation?.distance(from: selectedMarkerLocation)
        
        if let dist = distance {
            
            print("SelectedMarkerLocation: \(selectedMarkerLocation)")
            print("CurrentLocation: \(currentLocation)")
            print("Distance: \(dist)")
            
            if (Double(dist) < 5){
                
                performSegue(withIdentifier: "toNarrativeSegue", sender: self)
                
            }else {
                
                let alert = UIAlertController(title: "You are not at this hotspot", message: "Walk nearer to the hotspot to discover it", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        //performSegue(withIdentifier: "toNarrativeSegue", sender: self)
        
    }
    
    func initiateHotspots() {
        
        mapView.clear()
        
        let hotspots = InstanceDAO.hotspotDict
        let startHotspots = InstanceDAO.startHotspots
        
        if(InstanceDAO.isFirstTime){ // Only show starting hotspot
            
            let teamStartHotspot = startHotspots[InstanceDAO.team_id]
            let hotspot = hotspots[teamStartHotspot!]
            
            let coordinates = hotspot!.coordinates
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(coordinates[0]) ?? defaultCoordinates[0] , longitude: Double(coordinates[1]) ?? defaultCoordinates[1])
            marker.title = hotspot!.name
            marker.userData = hotspot!.narrative
            marker.snippet = "Click me to start mission!"
            marker.map = mapView

        }else { // Show all hotspots
            
            for (name, hotspot) in hotspots{
                print("name: \(name)")
                
                let coordinates = hotspot.coordinates
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(coordinates[0]) ?? defaultCoordinates[0] , longitude: Double(coordinates[1]) ?? defaultCoordinates[1])
                marker.title = name
                marker.userData = hotspot.narrative
                marker.snippet = "Click me to start mission!"
                marker.map = mapView
                
                if(InstanceDAO.completedList.contains(name)){
                    marker.icon = GMSMarker.markerImage(with: .green)
                    marker.title = nil
                    marker.snippet = nil
                }
            
            }
        }
        
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
        
        // update current location variable whenever location changes
        currentLocation = location
        //print("Location: \(location)")
        print(location.coordinate)
        
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
