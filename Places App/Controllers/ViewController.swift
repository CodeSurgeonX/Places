//
//  ViewController.swift
//  Places App
//
//  Created by Shashwat  on 04/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location = CLLocationManager()
    var coordinates = "28.612892,77.229431" //Dynamic
    var type = "restaurant" //Dynamic
    var locationRetrievalState : LocationState = .Fail
    var radius = "1000" //Dynamic
    var locationCoordinates : CLLocationCoordinate2D? = nil
    var isUpdating = false
    lazy var customTableView : UITableView = {
        let tv = UITableView(frame: view.bounds)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(UINib.init(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        tv.bounces = true
        tv.rowHeight = 75
        return tv
        
    }()
    
    lazy var radiusSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 500
        slider.addTarget(self, action: #selector(setRadius), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var radiusLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    
    lazy var categoryDataSource = ["accounting","airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar","beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe","campground","car_dealer","car_rental","car_repair","car_wash","casino","cemetery","church","city_hall","clothing_store","convenience_store","courthouse","dentist","department_store","doctor","electrician","electronics_store","embassy","fire_station","florist","funeral_home","furniture_store","gas_station","gym","hair_care","hardware_store","hindu_temple","home_goods_store","hospital","insurance_agency","jewelry_store","laundry","lawyer","library","liquor_store","local_government_office","locksmith","lodging","meal_delivery","meal_takeaway","mosque","movie_rental","movie_theater","moving_company","museum","night_club","painter","park","parking","pet_store","pharmacy","physiotherapist","plumber","police","post_office","real_estate_agency","restaurant","roofing_contractor","rv_park","school","shoe_store","shopping_mall","spa","stadium","storage","store","subway_station","supermarket","synagogue","taxi_stand","train_station","transit_station","travel_agency","veterinary_care","zoo"]
    
    var customUrlString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(radiusLabel)
        radiusLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        radiusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8).isActive = true
        radiusLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        radiusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.view.addSubview(radiusSlider)
        radiusSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        radiusSlider.rightAnchor.constraint(equalTo: radiusLabel.leftAnchor, constant: -8).isActive = true
        radiusSlider.heightAnchor.constraint(equalToConstant: 75).isActive = true
        radiusSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        

        
        self.view.addSubview(customTableView)
        customTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        customTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        customTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        customTableView.bottomAnchor.constraint(equalTo: radiusSlider.topAnchor, constant: 8).isActive = true
        setupLocationManager()
        

    }
    
    @objc func setRadius(){
        radius = String(Int(radiusSlider.value * 1000))
        radiusLabel.text = String(Int(radiusSlider.value))
    }
    
    
}

// MARK:TableViewMethods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        let text = categoryDataSource[indexPath.row]
        let elements = text.split(separator: "_")
        var finalString = ""
        for substring in elements {
            finalString.append(" " + substring.capitalized)
        }
        cell.categoryNameLabel.text = finalString
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicator.startAnimating()
        tableView.deselectRow(at: indexPath, animated: true)
        type = categoryDataSource[indexPath.row]
        customUrlString = constants.url + "key=\(constants.key)" + "&" + "location=\(coordinates)" + "&" + "radius=\(radius)" + "&" + "type=\(type)"
        makeAPICall(customUrlString)
    }
    
    
    
}
// MARK:LocationMenthods
extension ViewController  : CLLocationManagerDelegate {
    func setupLocationManager(){
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locus = locations[locations.count - 1]
        let latitude = locus.coordinate.latitude
        let longitude = locus.coordinate.longitude
        locationCoordinates = locus.coordinate
        coordinates.removeAll()
        coordinates.append(String(latitude)+",")
        coordinates.append(String(longitude))
        if locus.horizontalAccuracy > 0 {
            location.stopUpdatingLocation()                                        //Saves battery of the user
            locationRetrievalState = .Success
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationRetrievalState = .Fail
    }
}


// MARK:API Handling
extension ViewController {
    
    fileprivate func makeAPICall(_ customUrlString: String) {
        if let url = URL(string: customUrlString) {
            let command = PlacesCommand()
            command.getDataForUrl(url,responseHandler: { [weak self] (res) in
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
                switch res {
                case .success(let resulArray) :
                    self?.handleSuccess(result: resulArray)
                    break
                case .failure(let error) :
                    self?.handleFailure(error: error)
                    break
                }
            })
        }
    }
    
    func handleSuccess(result : [Any]) {
        if result.count == 0 {
            let alert = UIAlertController(title: "Found Nothing", message: "0 Results found, consider increasing the radius", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            DispatchQueue.main.async {
               self.present(alert, animated: true, completion: nil)
            }
        } else {
            //Present New View Controller
            var data = [MapEntity]()
            for res in result {
                if let convertedRes =  res as? [String:Any] {
                    let object = MapEntity(jsonData: convertedRes)
                    data.append(object)
                }
            }
            let specificCategoryVC = CategorySpecificViewController()
            specificCategoryVC.dataSource = data
            specificCategoryVC.delegate = self
            DispatchQueue.main.async { [weak self] in
                if self?.isUpdating == true {
                    self?.navigationController?.pushViewController(specificCategoryVC, animated: false)
                    self?.isUpdating = false
                }else {
                    self?.navigationController?.pushViewController(specificCategoryVC, animated: true)
                }
            }
        }
    }
    
    func handleFailure(error : ResponseError){
        var errorMessage = ""
        switch error {
        case .limitExceeded(let message):
            errorMessage = message
        case .errorCode(let code):
            errorMessage = "Error Code: \(code)"
        case .unknown :
            errorMessage = "Unknown Error"
        }
        
        let alert = UIAlertController(title: "Something Went Wrong", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension ViewController : CategorySpecificViewControllerDelegate {
    func updateAndReloadDataAndViews() {
        self.isUpdating = true
        location.startUpdatingLocation()
        self.navigationController?.popToRootViewController(animated: false)
//        customUrlString = constants.url + "key=\(constants.key)" + "&" + "location=\(coordinates)" + "&" + "radius=\(radius)" + "&" + "type=\(type)"
        makeAPICall(customUrlString)
    }
    

    
    func getRadius() -> Double? {
        if let radius = Double(radius) {
            return radius
        }
        return nil
    }
    

    
    func getMyPosition() -> CLLocationCoordinate2D? {
        if let coord = locationCoordinates {
            return coord
        }
        return nil
    }
    
    
    
    
    
    
}
