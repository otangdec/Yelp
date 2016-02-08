//
//  DetailViewController.swift
//  Yelp
//
//  Created by Oranuch on 2/2/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    
    @IBOutlet weak var displayPhoneLabel: UILabel!
 
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var businessName: UILabel!
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var businessMapView: MKMapView!

    var business: Business!
    var locationManager: CLLocationManager!
    var spanX: Float = 0.0
    var spanY: Float = 0.0

 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        UIApplication.sharedApplication()
        self.businessMapView.delegate = self
        
        businessName.text = business.name
        if business.imageURL != nil {
            reviewImageView.setImageWithURL(business.ratingImageURL!)
        }
        
        reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = business.fullAddress
        displayPhoneLabel.text = "Tel: \(business.displayPhone!)"
        bgImageView.setImageWithURL(business.imageURL!)

        
        let centerLocation = CLLocation(latitude: business.latitude, longitude: business.longitude)
        goToLocation(centerLocation)
        
        spanX = 0.00725;
        spanY = 0.00725;
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self // self does not work for some reason
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.distanceFilter = 200
//        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func callMapOnTouch(sender: AnyObject) {
        openMaps(business.fullAddress!)
    }
    
    func openMaps(address: String){
        // replace space with commas to make it work with map
        let addressString = "http://maps.apple.com/?address=\(address)".stringByReplacingOccurrencesOfString(" ", withString: ",")
        
        // delete the last character
        //let addressString = addressStringOriginal.substringToIndex(addressStringOriginal.endIndex.predecessor())

        UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        businessMapView.setRegion(region, animated: false)
        
        addPin(latitude: business.latitude, longitude: business.longitude, title: business.name!)
    }
    
    func addPin(latitude latitude: Double, longitude: Double, title: String) {
        
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = locationCoordinate
        annotation.title = title
        businessMapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!
        ) -> MKAnnotationView! {
        let annotationReuseId = "Place"
        var mapView = businessMapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
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
