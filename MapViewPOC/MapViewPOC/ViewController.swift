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

class ViewController: UIViewController, CLLocationManagerDelegate, AddCrumbleTableViewControllerDelegate {
    
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var crumbles = [CrumbleAnnotation]()
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
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
        var navController: UINavigationController = segue.destinationViewController as! UINavigationController
        var addCrumbleController: AddCrumbleTableViewController = navController.topViewController as! AddCrumbleTableViewController
        addCrumbleController.location = lastLocation
    }
    
    func getCrumbles() {
        var request = Alamofire.request(.GET, "http://77.175.219.85/getcrumbles.php")
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
        //println(jsonConverted)
        crumbles.removeAll(keepCapacity: false)
        for (index: String, subJson: JSON) in jsonConverted{
            var imagePath = subJson["crumbleImagePath"]
            var imagePathString = ""
            if imagePath == nil {
                imagePathString = ""
            }
            else {
                imagePathString = imagePath.string!
            }
            let crumble = CrumbleAnnotation(latitude: subJson["crumbleLat"].double!, longitude: subJson["crumbleLong"].double!, identifier: subJson["crumbleIdentifier"].int!, crumbleText: subJson["crumbleTekst"].string!, author: subJson["crumbleAuthor"].string!, imagePath: imagePathString, date: subJson["crumbleDate"].string!, title: subJson["crumbleTitle"].string!)
            crumbles.append(crumble)
            mapView.addAnnotation(crumble)
            addRadiusOverlayForCrumble(crumble)
        }
        //mapView.addAnnotations(crumbles)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        //println("plz do this")
        if annotation is CrumbleAnnotation {
            //println("annotation is CrumbleAnnotation")
            let identifier = "myPin"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                //MOGELIJKE REMOVE BUTTON MAKEN OID
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
            circleRenderer.strokeColor = UIColor.yellowColor()
            circleRenderer.fillColor = UIColor.yellowColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        return nil
    }
    
    //TODO Verwijder radius
    
    func addCrumbleTableViewControllerDidFinish(controller: AddCrumbleTableViewController) {
        getCrumbles()
        println("yeah")
    }
    
    func loadList(notification: NSNotification){
        //load data here
        getCrumbles()
    }
    
}


extension ViewController: MKMapViewDelegate {
    
}

