//
//  MDthree.swift
//  MDapp
//
//  Created by Andris Tolmanis on 14/04/2019.
//  Copyright © 2019 Andris Tolmanis. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MDthree: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var daMap: MKMapView!
    var locManager = CLLocationManager()
    var userCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locations = [[String: Any]]()
    var dbStuff: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbStuff = Database.database().reference()
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locManager.delegate = self
        self.daMap.delegate = self
        self.daMap.showsUserLocation = true
        locations = [
            [ "title": "Valmiera", "subtitle": "This is not Riga :O", "lat": 57.535067, "long": 25.424228, "show": true],
            [ "title": "Rīga", "subtitle": "This is Riga :D", "lat": 56.946285, "long": 24.105078, "show": true ],
            [ "title": "Ventspils", "subtitle": "This place is called Ventspils", "lat": 57.393722	, "long": 21.564707, "show": true ],
            [ "title": "Liepājaa", "subtitle": "", "lat": 56.504668, "long": 21.010806, "show": true ]
        ]
        for location in locations{
            let point = MKPointAnnotation()
            if let lat = location["lat"] as? Double,
                let long = location["long"] as? Double,
                let ti = location["title"] as? String,
                let su = location["subtitle"] as? String,
                let show = location["show"] as? Bool{
                    if(show == true){
                        point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long);
                        point.title = ti
                        point.subtitle = su
                        daMap.addAnnotation(point)
                    }
            }
        }
        dbStuff.child("locations").observe(.value){ snapshot in
            let data = snapshot.value as? [String: AnyObject] ?? [:]
            for (key,value) in data{
                let point = MKPointAnnotation()
                if let lat = value["lat"] as? Double,
                    let long = value["long"] as? Double,
                    let ti = value["title"] as? String,
                    let su = value["subtitle"] as? String,
                    let show = value["show"] as? Bool{
                    if(show == true){
                        point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long);
                        point.title = ti
                        point.subtitle = su
                        self.daMap.addAnnotation(point)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter", let vc = segue.destination as? MDthreeFilter{
            vc.locations = locations
        }
    }
    
    @IBAction func openFilter(_ sender: UIButton) {
    }
    func daMap(_ daMap: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView?{
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "Annotation"
        var annotationView = daMap.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }else{
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last{
            // Jump to user location
//            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//            self.daMap.setRegion(region, animated: true)
            userCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
        }
    }
    
    func mapView(_ MapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 2
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selected = view.annotation as? MKPointAnnotation
        self.daMap.removeOverlays(self.daMap.overlays)
        drawPath(targetCoord: CLLocationCoordinate2D(latitude: Double(selected?.coordinate.latitude ?? 0), longitude: Double(selected?.coordinate.longitude ?? 0)))
    }
    
    func drawPath(targetCoord:CLLocationCoordinate2D){
        let sourcePlaceMark = MKPlacemark(coordinate: userCoord)
        let destinationPlaceMark = MKPlacemark(coordinate: targetCoord)
        let source = MKMapItem(placemark: sourcePlaceMark)
        let directionRequest = MKDirections.Request()
        directionRequest.source = source
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        let directions = MKDirections(request: directionRequest)
        directions.calculate {response, error in
            if let route = response?.routes.first{
                self.daMap.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            }
        }
    }
}
