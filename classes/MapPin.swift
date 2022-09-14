//
//  MapPin.swift
//  marIA
//
//  Created by Bof on 30/04/22.
//  Copyright © 2022 marIA. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(_ title: String,_ locationName: String,_ coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
}
