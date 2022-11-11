//
//  MapViewController.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 10/11/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var mapAnnotation: MapAnnotationModel? = nil
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setMapViewDelagate()
        self.title = mapAnnotation?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let annotation = MKPointAnnotation()
        annotation.title = mapAnnotation?.name
        annotation.subtitle = mapAnnotation?.email
        annotation.coordinate = CLLocationCoordinate2D(latitude: mapAnnotation!.latitude, longitude: mapAnnotation!.longitude)
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate
        
    }
    
    // MARK: - SetMapViewDelegate

    func setMapViewDelagate(){
        mapView.delegate = self
    }
    // MARK: - MapViewDelegateMethods

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Int(log2(zoomWidth)) - 1
        print("...REGION DID CHANGE: ZOOM FACTOR \(zoomFactor)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    

}
