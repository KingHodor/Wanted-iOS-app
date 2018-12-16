//
//  SelectCityController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 31.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol SelectLocationDelegate: class {
    func selectLocation(_ result: String)
}

class SelectCityController: UIViewController, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource  {
    
    var closure: GooglePlaceSelectedClosure?
    fileprivate var apiKey: String = "AIzaSyCDEXMDls47wDG3u8_MFeuL2VrBWjaPOWc"
    fileprivate var places = [Place]()
    fileprivate var placeType: PlaceType = .cities
    fileprivate var coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    fileprivate var radius: Double = 0.0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    weak var selectLocationDelegate: SelectLocationDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.desingView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func desingView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.places = []
        if searchText.characters.count > 0 {
            getPlaces(searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    fileprivate func escape(_ string: String) -> String {
        //        let legalURLCharactersToBeEscaped: CFStringRef = ":/?&=;+!@#$()',*"
        return (string as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        //        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    /**
     Call the Google Places API and update the view with results.
     
     :param: searchString The search query
     */
    fileprivate func getPlaces(_ searchString: String) {
        var params = [
            "input": escape(searchString),
            "types": placeType.description,
            "language": "en-US",
            "sensor":"false",
            "libraries":"places",
            //"region":"us",
            "key": apiKey ?? ""
        ]
        if CLLocationCoordinate2DIsValid(self.coordinate) {
            
            params["location"] = "\(coordinate.latitude),\(coordinate.longitude)"
            if radius > 0 {
                params["radius"] = "\(radius)"
            }
        }
        print(escape(searchString))
        GooglePlacesRequestHelpers.doRequest(
            "https://maps.googleapis.com/maps/api/place/autocomplete/json",
            params: params
        ) { json in
            if let predictions = json["predictions"] as? [[String: AnyObject]] {
                self.places = predictions.map { (prediction: [String: AnyObject]) -> Place in
                    
                    return Place(prediction: prediction, apiKey: self.apiKey)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let place = self.places[safe: indexPath.row]
        {
            selectLocationDelegate?.selectLocation(place.description)
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath) as! SelectCityCell
        
        // Get the corresponding candy from our candies array
        
        if let place = self.places[safe: indexPath.row]
        {
          cell.addressLabel.text = place.description
        }
        else{
            return UITableViewCell()
        }
      
        return cell
    }

    @IBAction func handleDissmissButton(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
