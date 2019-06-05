//
//  CategorySpecificViewController.swift
//  Places App
//
//  Created by Shashwat  on 05/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit
import MapKit

protocol CategorySpecificViewControllerDelegate : class {
    func getMyPosition() -> CLLocationCoordinate2D?
    func getRadius() -> Double?
}

class CategorySpecificViewController: UIViewController {
    var delegate : CategorySpecificViewControllerDelegate?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet{
            valueChanged(nil)
        }
    }
    var dataSource = [MapEntity]()
    lazy var imageDownloader = ImageDownloader()
    
    var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight : CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(UINib(nibName: "customCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categorySpecificCell")
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    
    @IBAction func valueChanged(_ sender: AnyObject?) {
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            myCollectionView.isHidden = false
            mapView.isHidden = true
            break
        case 1:
            myCollectionView.isHidden = true
            mapView.isHidden = false
            renderMap()
        default:
            break
        }
    }
}


extension CategorySpecificViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorySpecificCell", for: indexPath) as! customCollectionViewCell
        let object = dataSource[indexPath.row]
        cell.nameLabel.text = object.name
        cell.ratingLabel.text = String(object.rating)
        if let url = object.getImageDownloadLink() {
            imageDownloader.downloadImageFromURL(urlString: url, imageView: cell.imageView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/2 - 16, height: 250)
    }
    
    func renderMap(){
        if delegate != nil {
            if let radius = delegate?.getRadius(), let coord = delegate?.getMyPosition() {
                if let latitudinal = CLLocationDistance(exactly: radius), let longitudinal = CLLocationDistance(exactly: radius) {
                    let region = MKCoordinateRegion(center: coord, latitudinalMeters: latitudinal, longitudinalMeters: longitudinal)
                    mapView.setRegion(region, animated: true)
                }
            }
        }
        for item in dataSource {
            if let anno =  item.getMapRepresentableAnnotation() {
                mapView.addAnnotation(anno)
            }
        }
    }
}

extension CategorySpecificViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MapAnnotation else { return nil }
        let identifier = "myMarker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
