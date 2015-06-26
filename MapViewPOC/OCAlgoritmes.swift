//
//  OCAlgoritmes.swift
//  
//
//  Created by Fhict on 19/06/15.
//
//

import UIKit

class OCAlgoritmes: NSObject {
    func euclidDistanceSquared(CLLocationCoordinate2D a, CLLocationCoordinate2D b) -> Double {
        var latDelta: Double
        latDelta = a.latitude - b.latitude
        var lonDelta: Double
        lonDelta = a.longitude - b.longitude
        
        return (latDelta * latDelta) + (lonDelta * lonDelta)
    }
    func bubbleClusteringWithAnnotations(annotationsToCluster: NSArray, radius: Double) -> NSArray {
        var clusteredAnnotations: NSArray
        var radiusSquared: Double
        for (annotation in annotationsToCluster) {
            // Find fitting existing cluster
            var foundCluster = false
            var annotationCoordinate:CLLocationCoordinate2D
            annotationCoordinate = annotation.coordinate
            for (crumbleAnnotation in clusteredAnnotations){
                // TODO Groups toevoegen
                // Annotation in range of cluster. Add it
                if(euclidDistanceSquared(annotationCoordinate, crumbleAnnotation.coordinate) <= radiusSquared) {
                    foundCluster = true
                    annotation.add(crumbleAnnotation)
                    break;
                }
            }
            // If annotation wasn't added to cluster, create new one
            if (!foundCluster) {
                var newCluster:ClusterAnnotation = annotation
                clusteredAnnotations.add(newCluster)
                
            }
            
        }
        // Whipe all empty or single annotations
        var returnArray: NSArray
        for (anAnnotation in clusteredAnnotations) {
            if (anAnnotation.annotationsInCluster.count == 1) {
                returnArray.add(anAnnotation.annotationsInCluster.last)
            }
            else if (anAnnotation.annotationsInCluster.count > 1) {
                returnArray.add(anAnnotation)
            }
        }
        return returnArrays
    }
    
}
