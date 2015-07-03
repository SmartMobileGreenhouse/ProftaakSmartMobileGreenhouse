//
//  ViewController.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 18-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var selectedCrumble: CrumbleAnnotation?
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var crumbles = [CrumbleAnnotation]()
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style
        var imageLogo = UIImage(named: "logo_crumble_white")
        var imageView = UIImageView(image: imageLogo)
        self.navigationController?.navigationBar.topItem?.titleView = imageView
        
        //Location manager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        
        //self.locationManager.requestWhenInUseAuthorization()
        //mapView.showsUserLocation = true
        if(CLLocationManager.locationServicesEnabled()) {
            //            locationManager.delegate = self
            //            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //            locationManager.startUpdatingLocation()
        }
        
        
        //Observer om de crumbles te laden
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
        
        getCrumbles()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            self.lastLocation = locations.last as? CLLocation
            if (error != nil) {
                println("Reverse geocoder failed with error \(error.localizedDescription)")
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        if(placemark.location != nil) {
            locationManager.stopUpdatingLocation()
            println(placemark.locality)
            println(placemark.postalCode)
            println(placemark.administrativeArea)
            println(placemark.country)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location \(error.localizedDescription)" )
    }
    
    func zoomToUserLocation(locationLast: CLLocation) {
        let location = locationLast
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.00001, longitudeDelta: 0.00001))
        self.mapView.setRegion(region, animated: true)
        
    }
    @IBAction func myLocation_Click(sender: AnyObject) {
        if(lastLocation != nil)
        {
            zoomToUserLocation(lastLocation!)
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showDetail") {
            var detailViewController: CrumbleDetailViewController = segue.destinationViewController as! CrumbleDetailViewController
            detailViewController.crumble = selectedCrumble
        }
        else{
            var navController: UINavigationController = segue.destinationViewController as! UINavigationController
            var addCrumbleController: AddCrumbleTableViewController = navController.topViewController as! AddCrumbleTableViewController
            addCrumbleController.location = lastLocation
        }
        
    }
    
    func getCrumbles() {
        var request = Alamofire.request(.POST, "http://77.175.219.85/getcrumbles.php", parameters: ["crumble":"crumble"])
        request.validate()
        /*
        Het antwoord van php.
        Als alles goed gaat komt er een popup met iets van: "Crumble geplaatst"
        Anders een errorbeschrijving in de output van bijvoorbeeld Xcode.
        */
        request.responseJSON(completionHandler: {
            (urlREQ, urlResp, responsestring, error) -> Void in
            if error == nil
            {
                //Uncomment als er iets mis is
                //println(responsestring)
                self.parseJsonData(responsestring)
                
            }
            else
            {
                //Something went wrong
                println(error)
            }
        })
    }
    
    func parseJsonData(jsonData:AnyObject?)
    {
        var jsonConverted = JSON(jsonData!)
        mapView.removeAnnotations(crumbles)
        var overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        crumbles.removeAll(keepCapacity: false)
        //Werkt blijkbaar alleen als subJson een array met objecten is!! (komt van swiftyjson af)
        for (index: String, subJson: JSON) in jsonConverted{
            var imagePath = subJson["crumbleImagePath"].string
            var imagePathString = ""
            if imagePath == nil {
                imagePathString = ""
            }
            else {
                imagePathString = imagePath!
            }
            let crumble = CrumbleAnnotation(latitude: subJson["crumbleLat"].double!, longitude: subJson["crumbleLong"].double!, identifier: subJson["crumbleIdentifier"].int!, crumbleText: subJson["crumbleTekst"].string!, author: subJson["crumbleAuthor"].string!, imagePath: imagePathString, date: subJson["crumbleDate"].string!, title: subJson["crumbleTitle"].string!)
            
//            var lat = subJson["crumbleLat"].string
//            var long = subJson["crumbleLong"].string
//            var id = subJson["crumbleIdentifier"].string
//            var text = subJson["crumbleTekst"].string
//            var author = subJson["crumbleAuthor"].string
//            var date = subJson["crumbleDate"].string
//            var title = subJson["crumbleTitle"].string
            
            crumbles.append(crumble)
            mapView.addAnnotation(crumble)
            addRadiusOverlayForCrumble(crumble)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is CrumbleAnnotation {
            let identifier = "myPin"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                //MOGELIJKE REMOVE BUTTON MAKEN OID
                //annotationView?.animatesDrop = true
                annotationView?.animatesDrop = false
                annotationView?.image = UIImage(named: "crumb.png")
                
                var button = UIButton.buttonWithType(.Custom) as! UIButton
                button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                button.setImage(UIImage(named: "forward")!, forState: .Normal)
                annotationView?.rightCalloutAccessoryView = button
            }
            else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func addRadiusOverlayForCrumble(crumble: CrumbleAnnotation) {
        mapView.addOverlay(MKCircle(centerCoordinate: crumble.coordinate, radius: crumble.radius))
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.blueColor()
            circleRenderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var crumble = view.annotation as! CrumbleAnnotation
        selectedCrumble = crumble
        performSegueWithIdentifier("showDetail", sender: self)
    }

    
    func loadList(notification: NSNotification){
        //load data here
        getCrumbles()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .AuthorizedWhenInUse)
    }
}


extension ViewController: MKMapViewDelegate {
    
}

