//
//  Hotspots.swift
//  Engagingu
//
//  Created by Raylene on 1/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//struct Hotspot: Decodable{ //create a Hotspot class use for the jsondecoder
//
//    let coordinates: [String]
//    let name: String
//    let narrative: String
//}

class Hotspots: UIViewController {


    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 9000
    
    override func viewDidLoad() {
        super.viewDidLoad( )
        checkLocationServices()
        
        //json call
        let jsonUrlString = "http://54.255.245.23:3000/hotspot/getAllHotspots?trail_instance_id=1"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok

            guard let data = data else { return }
            
            do {
                let hotspots = try
                    JSONDecoder().decode([Hotspot].self, from: data)
                
                for hotspot in hotspots{
                    self.addAnnotations(lat: hotspot.coordinates[0], long: hotspot.coordinates[1], name: hotspot.name, narrative: hotspot.narrative)
                }
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
        }.resume()
        
        // Do any additional setup after loading the view.
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters) //set how much i want to zoom in to my current location, smaller number more zoomed in
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            //setup the location manager
            setupLocationManager()
            checkLocationAuthorization()
            locationManager.startUpdatingLocation() //firing the delegate method below: didUpdateLocations
        } else{
            //show alert to user that they need to turn on their location access
            print("Location access disabled") //debugging message
        }
    }
    
    func addAnnotations(lat: String, long: String, name: String, narrative: String){
        
        let lati = (lat as NSString).doubleValue
        let longi = (long as NSString).doubleValue
        
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = CLLocationCoordinate2DMake(lati, longi)
        
        mapView.addAnnotation(annotation)
    }
    
   
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){ //5 cases to handle
        case .authorizedAlways, .authorizedWhenInUse: //app can get your location when app is in the background
            //what we want, do map stuff here
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
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

extension Hotspots: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //this function fires off when there is an update on the user's location
        //guard let location = locations.last else { return } //guard against no location, if no location, return nothing
        //this will recenter the map to usr's location so i removed it else will keep jumping to the user location
//        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) //the map view center is the user's last location
//
//        mapView.setCenter(center, animated: true) //so that map is still centered without changing the zoom value
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { //whenever authorization changes; run through switch statements on top
        
        checkLocationAuthorization()

    }
}
