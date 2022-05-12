//
//  ViewController.swift
//  StudyMapView
//
//  Created by app on 2022/05/12.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    var previousCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapviewSetting()
    }

    func mapviewSetting() {
        getLocationUsagePermission()
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .notDetermined:
            Logger.d("GPS권한 설정되지 않음.")
            getLocationUsagePermission()
        case .denied:
            Logger.d("GPS권한 요청 거부됨.")
            getLocationUsagePermission()
        case .authorizedAlways, .authorizedWhenInUse:
            Logger.d("GPS권한 설정됨.")
            //중요!
            self.locationManager.startUpdatingLocation()
        default:
            Logger.d("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        if let previousCoordinate = self.previousCoordinate {
            
            var points: [CLLocationCoordinate2D] = []
            
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            
            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
            
            points.append(point1)
            points.append(point2)
            
            let lineDraw = MKPolyline(coordinates: points, count: points.count)
            self.mapView.addOverlay(lineDraw)
        }
        
        
        self.previousCoordinate = location.coordinate
    }
}


extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else {
            Logger.d("can't draw polyline")
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .red
        renderer.lineWidth = 3.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
