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
    
    let mapView: MKMapView = MKMapView()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapviewSetting()
    }

    func mapviewSetting() {
        getLocationUsagePermission()
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
        // the most recent location update is at the end of the array.
        let location: CLLocation = locations[locations.count - 1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude
        Logger.i("\(longtitude), \(latitude)")
    }
}
