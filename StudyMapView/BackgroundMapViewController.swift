//
//  BackgroundMapViewController.swift
//  StudyMapView
//
//  Created by app on 2022/05/13.
//

import UIKit
import MapKit
import RealmSwift

class BackgroundMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel1.text = ""
        infoLabel2.text = ""
        statusLabel.text = ""
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func goLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let coordinate2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let coordinateRegion = MKCoordinateRegion(center: coordinate2d, span: coordinateSpan)
        mapView.setRegion(coordinateRegion, animated: true)
        return coordinate2d
    }
    
    func setAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta span: Double, title strTitle: String, subTitle strSubTitle: String, pinColor color: UIColor) {
        let annotation = ColorPointAnnotation()
        annotation.coordinate = goLocation(latitude: latitude, longitude: longitude, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        annotation.pinTintColor = color
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        let latitude = (lastLocation?.coordinate.latitude)!
        let longitude = (lastLocation?.coordinate.longitude)!
        
        Logger.d("latitude is \(latitude), longitude is \(longitude)")
        
//        let locationInfo: LocationInfo = LocationInfo()
    }

}

class ColorPointAnnotation: MKPointAnnotation {
    var pinTintColor: UIColor?
}
