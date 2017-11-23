//
//  FinderViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 23/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FinderViewController: DetailViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate{
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var map: MKMapView!
    
    let model = SingletonManager.model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.map.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.pickUpLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let location = model.pickUpLocations[indexPath.row]
        
        cell.textLabel?.text = location["street"]
        
        cell.detailTextLabel?.text = location["suburb"]! + ", " + location["postcode"]! + " " + location["state"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.map.removeAnnotations(self.map.annotations)
        
        let pickUpLocation = model.pickUpLocations[indexPath.row]
        
        
        let address = pickUpLocation["street"]! + ", " + pickUpLocation["suburb"]! + ", " + pickUpLocation["state"]! + pickUpLocation["postcode"]!
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Suburb"
            
            self.map.addAnnotation(annotation)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.map.setRegion(region, animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pinAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        annotationView?.annotation = annotation
        return annotationView
    }
    
}
