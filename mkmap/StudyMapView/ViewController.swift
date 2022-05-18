//
//  ViewController.swift
//  StudyMapView
//
//  Created by app on 2022/05/12.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

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
    var timer: Timer?
    var count: CGFloat = 0.00001
    var mark1: Marker = .init(title: "가산디지털단지역", subtitle: "출근 시 피난민 대열 주의!", coordinate: CLLocationCoordinate2D(latitude: 37.481605094093034, longitude: 126.88263612461213))
    var mark2: Marker = .init(title: "스타벅스", subtitle: "커피마시러 가고 싶다..", coordinate: CLLocationCoordinate2D(latitude: 37.48134929396545, longitude: 126.88363429195765))
    var layerCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapviewSetting()
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveLocation), userInfo: nil, repeats: true)
    }
    
    deinit {
        mapView.delegate = nil
    }

    func mapviewSetting() {
        getLocationUsagePermission()
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard
        self.mapView.showsUserLocation = false
        self.mapView.setUserTrackingMode(.follow, animated: true)
        self.mapView.addAnnotations([mark1, mark2])
    }
    
    func getLocationUsagePermission() {
//        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
    }
    
    @objc func moveLocation() {

        mark1 = Marker(title: mark1.title, subtitle: mark1.subtitle, coordinate: CLLocationCoordinate2D(latitude: mark1.coordinate.latitude + count, longitude: mark1.coordinate.longitude + count))
        mark2 = Marker(title: mark2.title, subtitle: mark2.subtitle, coordinate: CLLocationCoordinate2D(latitude: mark2.coordinate.latitude - count, longitude: mark2.coordinate.longitude - count))
//        addCircle(locationCoordinate: self.mapView.userLocation.coordinate)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations([mark1, mark2])
        
    }
    
    func addCircle(locationCoordinate: CLLocationCoordinate2D) {
        self.mapView.removeOverlays(self.mapView.overlays)
        Logger.d(layerCount)
        layerCount += 1
        let circle = MKCircle(center: locationCoordinate, radius: 100 as CLLocationDistance)
        self.mapView.addOverlay(circle)
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
        Logger.i(latitude)
        Logger.i(longtitude)
        
        if let previousCoordinate = self.previousCoordinate {
            
            var points: [CLLocationCoordinate2D] = []
            
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            
            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
            
            points.append(point1)
            points.append(point2)
            
            let lineDraw = MKPolyline(coordinates: points, count: points.count)
            self.mapView.addOverlay(lineDraw)
            
        }
        
        DispatchQueue.main.async {
            Logger.i(self.mapView.userLocation.coordinate)
            self.addCircle(locationCoordinate: self.mapView.userLocation.coordinate)
        }
        
        self.previousCoordinate = location.coordinate
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = .red
            circleRenderer.fillColor = UIColor.yellow.withAlphaComponent(0.3)
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        } else if let polyLine = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = .red
            renderer.lineWidth = 3.0
            renderer.alpha = 1.0
            
            return renderer
        } else {
            return MKOverlayRenderer()
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annotationView = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "me")
            annotationView.image = UIImage(named: "smile")

            let annotationLabel = UILabel(frame: CGRect(x: 0, y: -35, width: 45, height: 15))
            annotationLabel.backgroundColor = .systemOrange
            annotationLabel.textColor = .white
            annotationLabel.numberOfLines = 3
            annotationLabel.textAlignment = .center
            annotationLabel.font = UIFont.boldSystemFont(ofSize: 10)
            annotationLabel.text = annotation.title!
            
            annotationView.addSubview(annotationLabel)
            return annotationView
        } else {
            var annotationView: MKAnnotationView?
            annotationView = .init(annotation: annotation, reuseIdentifier: "others")
            
            let annotationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            let image = UIImage(named: "corgi")
            annotationImageView.image = image
            
            let annotationLabel = UILabel(frame: CGRect(x: 0, y: -35, width: 45, height: 15))
            annotationLabel.backgroundColor = .systemOrange
            annotationLabel.textColor = .white
            annotationLabel.numberOfLines = 3
            annotationLabel.textAlignment = .center
            annotationLabel.font = UIFont.boldSystemFont(ofSize: 10)
            annotationLabel.text = annotation.title!
            
            annotationView?.addSubview(annotationImageView)
            annotationView?.addSubview(annotationLabel)
            
            return annotationView
        }
    }
}
