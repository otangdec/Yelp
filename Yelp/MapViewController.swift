//
//  MapViewController.swift
//  Yelp
//
//  Created by Oranuch on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var businessesMap: MKMapView!
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var centerLocation = CLLocation()
        if businesses.count > 0 {
            centerLocation = CLLocation(latitude: businesses[0].latitude, longitude: businesses[0].longitude)
        } else {
            centerLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        }
        goToLocation(centerLocation)
        // Do any additional setup after loading the view.
    }
//    // get user location
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        businessesMap.setRegion(region, animated: false)
        
        for business in businesses{
            addPin(latitude: business.latitude, longitude: business.longitude, title: business.name!)
        }
    }
    
    func addPin(latitude latitude: Double, longitude: Double, title: String) {
        
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = locationCoordinate
        annotation.title = title
        businessesMap.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!
        ) -> MKAnnotationView! {
            let annotationReuseId = "Place"
            var mapView = businessesMap.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
            if mapView == nil {
                mapView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
            } else {
                mapView!.annotation = annotation
            }
            mapView!.image = UIImage(named: "yelp-pin")
            mapView!.backgroundColor = UIColor.clearColor()
            mapView!.canShowCallout = false
            return mapView
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
