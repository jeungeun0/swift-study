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
//    var userPinView: MKAnnotationView!
    
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
        self.mapView.showsUserLocation = false
        self.mapView.setUserTrackingMode(.follow, animated: true)
        
//        let annotation1 = MKPointAnnotation()
//        let annotation2 = MKPointAnnotation()
//        annotation1.title = "Cogi"
//        annotation1.coordinate = CLLocationCoordinate2D(latitude: 37.493756090870505, longitude: 126.88822023477557)
//        annotation2.title = "Chiwawa"
//        annotation2.coordinate = CLLocationCoordinate2D(latitude: 37.48698230842552, longitude: 126.89012990329839)
        
        let mark1 = Marker(title: "가산디지털단지역", subtitle: "출근 시 피난민 대열 주의!", coordinate: CLLocationCoordinate2D(latitude: 37.481605094093034, longitude: 126.88263612461213))
        let mark2 = Marker(title: "스타벅스", subtitle: "커피마시러 가고 싶다..", coordinate: CLLocationCoordinate2D(latitude: 37.48134929396545, longitude: 126.88363429195765))
        
        self.mapView.addAnnotation(mark1)
        self.mapView.addAnnotation(mark2)
        detectMarkerLocation()
//        self.mapView.addAnnotation(annotation1)
//        self.mapView.addAnnotations([annotation1, annotation2])
    }
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func detectMarkerLocation() {
        let center = CLLocationCoordinate2D(latitude: 37.481605094093034, longitude: 126.88263612461213)
        let region = 100.0
        
        //이건 왜 하는 거지?
        let locationRegion = CLCircularRegion(center: center, radius: region, identifier: "subway")
        
        let circle = MKCircle(center: center, radius: region)
        
        mapView.addOverlay(circle)
        
        for marker in mapView.annotations {
            if locationRegion.contains(marker.coordinate) {
                print("\(String(describing: marker.title))은 가산디지털단지역 범위에 포함되었습니다.")
            } else {
                print("\(String(describing: marker.title))은 가산디지털단지역 범위에 포함되지 않았습니다.")
            }
        }
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
        
        /**
         이동 경로 표시하는 코드
         guard let polyLine = overlay as? MKPolyline else {
             Logger.d("can't draw polyline")
             return MKOverlayRenderer()
         }
         
         let renderer = MKPolylineRenderer(polyline: polyLine)
         renderer.strokeColor = .red
         renderer.lineWidth = 3.0
         renderer.alpha = 1.0
         
         return renderer
         */
        
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = UIColor.yellow.withAlphaComponent(0.3)
        circleRenderer.lineWidth = 1.0
        return circleRenderer
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /**
         현재위치의 이미지와 다른 위치의 이미지를 다르게 설정하는 코드
         if annotation is MKUserLocation {
             
             let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
             pin.image = UIImage(named: "smile")
 //            userPinView = pin
             return pin
         } else {
             //handle other annotations
             
             let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
             pin.image = UIImage(named: "corgi")
             return pin
         }
         return nil
         */
        
        /**
         var annotationView: MKAnnotationView?
         annotationView = .init(annotation: annotation, reuseIdentifier: "default")
         
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
         */
        var annotationView: MKAnnotationView?
        annotationView = .init(annotation: annotation, reuseIdentifier: "default")
        
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
