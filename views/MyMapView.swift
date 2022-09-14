//
//  MapView.swift
//  marIA
//
//  Created by Bof on 27/04/22.
//  Copyright © 2022 marIA. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
  @IBOutlet var mapView: MKMapView!

  var managedObjectContext: NSManagedObjectContext!

  // MARK: - Actions
  @IBAction func showUser() {
    let region = MKCoordinateRegion(
      center: mapView.userLocation.coordinate,
      latitudinalMeters: 1000,
      longitudinalMeters: 1000)
    mapView.setRegion(
      mapView.regionThatFits(region),
      animated: true)
  }

  @IBAction func showLocations() {
  }
}

extension MapViewController: MKMapViewDelegate {
}
