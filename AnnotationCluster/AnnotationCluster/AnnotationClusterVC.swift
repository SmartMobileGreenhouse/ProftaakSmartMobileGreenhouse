//
//  AnnotationClusterVC.swift
//  AnnotationCluster
//
//  Created by Fhict on 18/06/15.
//  Copyright (c) 2015 Fhict. All rights reserved.
//

import UIKit

class AnnotationClusterVC: UIViewController {

    IBOutlet mapView = OCMapView(); // Nog veranderen
    self.mapView.delegate = self; // Nog veranderen
    self.mapView.clusterSize = 0.2; // Nog veranderen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(aMapView: MKMapView!, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        var annotationView = MKAnnotationView()
        // if it's a cluster
        if (annotation.isKindOfClass(OCAnnotation)) {
            
            let clusterAnnotation = annotation as (OCAnnotation);
            
            annotationView = aMapView.dequeueReusableAnnotationViewWithIdentifier("ClusterView") as (MKAnnotationView)
            
            if (annotationView == nil) {
                annotationView = initWithAnnotation(annotation: MKAnnotation, reustIdentifier: "ClusterView")
                annotationView.canShowCallout = YES;
                annotationView.centerOffset = CGPointMake(0, -20);
            }
            
            // set title
            clusterAnnotation.title = "Cluster";
            clusterAnnotation.subtitle = "Containing annotations: \(clusterAnnotation.annotationsInCluster)"
            
            // set its image
            annotationView.image = UIImage(named: "regular.png")
            
            // change pin image for group
            if (self.mapView.clusterByGroupTag) {
                annotationView.image = UIImage(imageNamed:"bananas.png")
                
                clusterAnnotation.title = clusterAnnotation.groupTag;
            }
        }
        // If it's a single annotation
        else if(annotation.isKindOfClass(OCMapViewSampleHelpAnnotation)){
            let singleAnnotation = annotation as (OCMapViewSampleHelpAnnotation)

            annotationView = aMapView.dequeueReusableAnnotationViewWithIdentifier("ClusterView") as (MKAnnotationView)
            
            if (!annotationView) {
                annotationView = initWithAnnotation(singleAnnotation: MKAnnotation, reustIdentifier: "singleAnnotationView") as (MKAnnotationView)
                annotationView.canShowCallout = YES;
                annotationView.centerOffset = CGPointMake(0, -20);
            }
            singleAnnotation.title = singleAnnotation.groupTag;
            annotationView.image = UIImage(imageNamed:"Banana.png");
            
        }
        // Error
        else {
            annotationView = initWithAnnotation(annotation: MKAnnotation, reustIdentifier: "errorAnnotationView") as (MKAnnotationView)
            if (!annotationView) {
                annotationView = initWithAnnotation(annotation: MKAnnotation, reustIdentifier: "errorAnnotationView") as (MKAnnotationView)
                 annotationView.canShowCallout = NO;
            }
        }
        return annotationView;
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
