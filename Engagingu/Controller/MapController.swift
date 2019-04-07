//  MapController.swift
//  Engagingu

import UIKit
import GoogleMaps
import GooglePlaces

// MapController initialises google maps with the hotspot markers
class MapController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapViewFrame: UIView!
    var defaultCoordinates = [1,2968, 103.8522]
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 17.0
    var selectedMarker: GMSMarker!
    
    override func viewDidLoad() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 5
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
        
        // Add the map to the view
        view.addSubview(mapView)
        
        // Animate camera to location
        mapView.animate(to: camera)
        
        // Refresh hotspots
        initiateHotspots()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear Map Controller")
        
        //re intiate hotspots and display new updated hotspot
        initiateHotspots()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // set camera to current location
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? defaultCoordinates[0],
                                              longitude: locationManager.location?.coordinate.longitude ?? defaultCoordinates[1],
                                              zoom: zoomLevel)
        
        mapView.animate(to: camera)
        
        // Save credentials to session
        saveCredentialsToSession()
        
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
            
            // Distance where user is allowed to click on hotspot in metres
            let distanceThreshold: Double = 10000
            
            if (Double(dist) <= distanceThreshold){
                
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
        
    }
    
    // Reintialise the marker that shows the hotspot
    // If hotspot not completed, marker is in orange
    // else marker is green
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
    
    func saveCredentialsToSession(){
        
        let def = UserDefaults.standard
        def.set(InstanceDAO.team_id, forKey: "team_id")
        print("Saved team_id \(InstanceDAO.team_id) to session")
        def.set(InstanceDAO.trail_instance_id, forKey: "trail_instance_id")
        print("Saved trail_instance_id \(InstanceDAO.trail_instance_id) to session")
        def.set(InstanceDAO.username, forKey: "username")
        print("Saved username \(InstanceDAO.username) to session")
        def.set(InstanceDAO.isLeader, forKey: "isLeader")
        print("Saved isLeader \(InstanceDAO.isLeader) to session")
        def.set(InstanceDAO.completedList, forKey: "completedList")
        print("Saved completedList \(InstanceDAO.completedList) to session")
        def.set(InstanceDAO.startHotspots, forKey: "startHotspots")
        print("Saved startHotspots \(InstanceDAO.startHotspots) to session")
        def.synchronize()
        
    }
    
}

extension MapController: CLLocationManagerDelegate{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        // update current location variable whenever location changes
        currentLocation = location
        
        if(InstanceDAO.isLeader){
            // send location to server
            var jsonDict: [String: String] = ["teamID": InstanceDAO.team_id]
            jsonDict["long"] = String(location.coordinate.longitude)
            jsonDict["lat"] = String(location.coordinate.latitude)
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) else { return
                print("Error: cannot create jsonData")
            }
            
            guard let updateLocationURL = InstanceDAO.serverEndpoints["updateLocation"] else {
                print("Unable to get server endpoint for updateScoreURL")
                return
            }
            _ = RestAPIManager.asyncHttpPost(jsonData: jsonData, URLStr: updateLocationURL)
            
            print("Sent Location to Backend")
        }
        
        if(InstanceDAO.isFirstTime){
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
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
