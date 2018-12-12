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

    override func viewDidLoad() {
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

}
