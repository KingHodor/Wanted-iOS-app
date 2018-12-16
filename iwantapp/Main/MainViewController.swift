//
//  MainViewController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 2.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit
import Foundation
import Darwin
import MapKit
import FBSDKLoginKit
import GoogleMobileAds

public protocol LoginViewDelegate: class {
    func checkFacebookButton()
}
class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FilterApplyDelegate, SettingsControllerDelegate, SearchApplyDelegate  {
    
    @IBOutlet weak var admobBanner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var lastLat  : Float?
    private var lastLong : Float?
    private var currentManager: CLLocationManager?
    private let locationManager = CLLocationManager()
    private var locationFlag:Bool = true
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private var refreshController:UIRefreshControl!
    var currentPage:Int64 = 0
    var type:Int = 1
    let pinkishGrey = UIColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
    weak var loginViewDelegate: LoginViewDelegate? = nil
    var isFirstClick:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.desingView()
        self.createIndicator()
        self.adMobBanner()
        SearchKeywordData.sharedInstance.fillSearchList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.findLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func adMobBanner(){
        admobBanner.adUnitID = "ca-app-pub-4718763794985958/6843155589"
        admobBanner.rootViewController = self
        //self.view.addSubview(admobBanner)
        var request: GADRequest = GADRequest()
        admobBanner.load(request)
    }
    
    private func desingView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        let collectionViewFlowControl = UICollectionViewFlowLayout()
        collectionViewFlowControl.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionViewFlowControl.minimumInteritemSpacing = 0
        collectionViewFlowControl.minimumLineSpacing = 0
        collectionView.collectionViewLayout = collectionViewFlowControl
        self.collectionView.isPagingEnabled = false
        
        
        //WantActivityData.fillTestData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        refreshController.tintColor = UIColor(red: 20/255, green: 141/255, blue: 210/255, alpha: 1)
        tableView.addSubview(refreshController)
        
        if  FilterData.sharedInstance.initialize == false{
            for _ in 0 ..< CategoryData.sharedInstance.categoryList.count{
                FilterData.sharedInstance.categories.append(true)
            }
            FilterData.sharedInstance.initialize = true
        }
    }
    
    @objc func refresh(_ sender:AnyObject) {
        currentPage = 0
        type = 2
        getNextPage()
    }
    
    private func callForCategory() {
        currentPage = 0
        type = 4
        getNextPage()
    }
    
    private func createIndicator(){
        indicator.hidesWhenStopped = true;
        indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.white;
        
        self.indicator.color = UIColor(red: 20/255, green: 141/255, blue: 210/255, alpha: 1)
        self.view.addSubview(self.indicator)
        self.view.bringSubview(toFront: indicator)
        self.indicator.center = self.view.center
        indicator.stopAnimating()
    }
    
    private func findLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationFlag == true {
            locationFlag = false
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            locationManager.stopUpdatingLocation()
            let latitude  = Float(locValue.latitude)
            let longitude = Float(locValue.longitude)
            User.sharedInstance.latitude = latitude
            User.sharedInstance.longitude = longitude
            User.sharedInstance.saveUserValues()
            self.callGoogleMapsAPI(latitude: latitude, longitude: longitude)
            /*if User.sharedInstance.city != "" && User.sharedInstance.country != ""{
                self.locationLabel.text = User.sharedInstance.city  + ", " + User.sharedInstance.country
                type = 1
                currentPage = 0
                getNextPage()
                if FilterData.sharedInstance.city == nil{
                   FilterData.sharedInstance.city = User.sharedInstance.city
                }
                if FilterData.sharedInstance.country == nil{
                    FilterData.sharedInstance.country = User.sharedInstance.country
                }
            }
            else{
                self.callGoogleMapsAPI(latitude: latitude, longitude: longitude)
            }*/
        }
        
    }
    
    private func callGoogleMapsAPI(latitude:Float, longitude:Float) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            if let city = addressDict["City"] as? String {
                print(city)
                if let country = addressDict["Country"] as? String {
                    print(country)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { ()->() in
                        User.sharedInstance.city = city
                        User.sharedInstance.country = country
                        self.tableView.reloadData()
                        User.sharedInstance.saveUserValues()
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            POST.sharedInstance.callPutUpdate("", userEmail: "", userPhone: "", city: city, country: country, emailPrefer: User.sharedInstance.emailPrefer, phonePrefer: User.sharedInstance.phonePrefer, done: self.responseToUpdate)
                        })
                        
                    })
                }
            }
        })
    }
    
    fileprivate func responseToUpdate(_ data:Data?){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                let result = json["result"]
                print(result)
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.locationLabel.text = User.sharedInstance.city  + ", " + User.sharedInstance.country
                    self.type = 1
                    self.currentPage = 0
                    self.getNextPage()
                    if FilterData.sharedInstance.city == nil{
                        FilterData.sharedInstance.city = User.sharedInstance.city
                    }
                    if FilterData.sharedInstance.country == nil{
                        FilterData.sharedInstance.country = User.sharedInstance.country
                    }
                })
            }
            else{
                
            }
        } catch {
            
        }
    }
    
    private func callGoogleMapsAPI1(latitude:Float, longitude:Float) -> String{
        let latlng = String(latitude) + "," + String(longitude)
        let language = "ja"
        let obsulateURL = "\(geoBaseUrl)latlng=\(latlng)&key=\(geoCodeApikey)&sensor=false&language=tr"
        print(obsulateURL)
        let url = URL(string: obsulateURL)
        let data = try? Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        var found:Bool = false
        if let status =  json["status"] as? String{
            if status == "OK"{
                if let results = json["results"] as? NSArray {
                    if results.count > 0{
                        if let result = results[0] as? NSDictionary{
                            if let address_components = result["address_components"] as? NSArray {
                                
                                for i in 0 ..< address_components.count{
                                    if let address_component = address_components[i] as? NSDictionary{
                                        
                                        if let types = address_component["types"] as? NSArray{
                                            
                                            for j in 0 ..< types.count{
                                                if let type = types[j]  as? String{
                                                    if type == "locality"{
                                                        found = true
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        if found == true{
                                            if let city = address_component["long_name"] as? String{
                                                return city
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return "Unknown"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return CategoryData.sharedInstance.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as? CategoryCell
        let index = indexPath.item
        let categoryData:Category = CategoryData.sharedInstance.categoryList[index + 1]!
        cell?.image.image = categoryData.w_image
        cell?.label.text = categoryData.name
        cell?.label.textColor = UIColor.white
        if FilterData.sharedInstance.categories[index] == true{
            cell?.backgroundColor = categoryData.color
        }else{
            cell?.backgroundColor = pinkishGrey
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 83.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if isFirstClick == true {
            if FilterData.sharedInstance.categories[index] == true {
                FilterData.sharedInstance.categories[index] = false
            }
            else{
                FilterData.sharedInstance.categories[index] = true
            }
        }
        else{
           isFirstClick = true
            for i in 0 ..< CategoryData.sharedInstance.categoryList.count{
                FilterData.sharedInstance.categories[i] = false
            }
           FilterData.sharedInstance.categories[index] = true
        }
        self.collectionView.reloadData()
        self.callForCategory()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WantActivityData.activityList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:WantActivityCell = tableView.dequeueReusableCell(withIdentifier: "WantActivityCell") as! WantActivityCell
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WantActivityCell = tableView.dequeueReusableCell(withIdentifier: "WantActivityCell") as! WantActivityCell
        let index = indexPath.item
        
        let wantActivity = WantActivityData.activityList[index]
        let id = wantActivity.category
        if let category = CategoryData.sharedInstance.categoryList[id!]{
            cell.wantImgView.image = category.c_image
            cell.WantLabel.text = wantActivity.want
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height :CGFloat = 0.0
        height = CGFloat(56)
        return height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "detailSegue"){
            if let indexPath = sender as? IndexPath{
                if let viewController = segue.destination as? WantDetailsController {
                    viewController.wantActivity = WantActivityData.activityList[indexPath.item]
                }
            }
        }else if(segue.identifier == "settingsSegue"){
            if let viewController = segue.destination as? SettingsController {
                viewController.settingsControllerDelegate = self
            }
        }
    }
    
    @IBAction func newWantAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup =  storyboard.instantiateViewController(withIdentifier: "NewWantController") as? NewWantController
        
        popup?.modalPresentationStyle = .currentContext
        popup?.modalTransitionStyle = .coverVertical
        popup?.type = 0
        self.present(popup!, animated:true, completion: nil)
    }
    
    @IBAction func openSettingsController(_ sender: Any){
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let settingsView =  storyboard.instantiateViewController(withIdentifier: "SettingsController")
        //        self.presentDetail(settingsView)
        self.performSegue(withIdentifier: "settingsSegue", sender: sender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentLarger = (scrollView.contentSize.height > scrollView.frame.size.height)
        let viewableHeight = contentLarger ? scrollView.frame.size.height : scrollView.contentSize.height
        let atBottom = (scrollView.contentOffset.y >= scrollView.contentSize.height - viewableHeight + 50)
        if atBottom && !tableView.isLoadingFooterShowing() {
            getNextPage()
            type = 3
        }
    }
    
    func getNextPage(search:String) {
        if currentPage == 0 {
            if type == 1 || type == 4 || type == 5{
               indicator.startAnimating()
            }
        }
        else{
            tableView.showLoadingFooter()
        }
        let categoryFilter = calcCategoryFilter()
        POST.sharedInstance.callWanters(currentPage, categoryFilter: categoryFilter, search: search, done: responseGetWanters)
    }
    
    func getNextPage() {
        if currentPage == 0 {
            if type == 1 || type == 4 || type == 5{
                indicator.startAnimating()
            }
        }
        else{
            tableView.showLoadingFooter()
        }
        let categoryFilter = calcCategoryFilter() // 1048575
        POST.sharedInstance.callWanters(currentPage, categoryFilter: categoryFilter, search: "", done: responseGetWanters)
    }
    
    private func calcCategoryFilter() -> Int{
        var total = 0
        for i in 0 ..< CategoryData.sharedInstance.categoryList.count{
            if FilterData.sharedInstance.categories[i] == true{
                total = total + getPower(a: 2, b: i)
            }
        }
        return total
    }
    
    private func getPower(a: Int, b:Int) -> Int{
        let x: Int = Int(pow(Double(a),Double(b)))
        return x
    }
    
    fileprivate func responseGetWanters(_ data:Data?){
        //WantActivityData.activityList
        do {
            let json = try JSON(data: data!)
            let error = json["error"]
            if error == nil{
                
                if type != 3{
                    WantActivityData.activityList.removeAll()
                }
                print(json)
                WantAmplitude.sharedInstance.log_event(log: json.rawString()!)
                let wanters = json["result"].arrayValue
                if wanters.count > 0{
                    for i in (0 ..< wanters.count){
                        
                        let id = wanters[i]["id"].intValue
                        let want = wanters[i]["want"].stringValue
                        let category = wanters[i]["category"].intValue
                        let phone = wanters[i]["phone"].stringValue
                        let email = wanters[i]["email"].stringValue
                        let minPrice = wanters[i]["minPrice"].doubleValue
                        let maxPrice = wanters[i]["maxPrice"].doubleValue
                        let description = wanters[i]["description"].stringValue
                        let city = wanters[i]["city"].stringValue
                        let currency = wanters[i]["currency"].stringValue
                        let country = wanters[i]["country"].stringValue
                        let emailPrefer = wanters[i]["emailPrefer"].intValue
                        let phonePrefer = wanters[i]["phonePrefer"].intValue
                        let wantActivity = WantActivity(want: want, category: category, phone: phone, email: email, minPrice: minPrice, maxPrice: maxPrice, city: city, country: country, currency: currency, description: description, emailPrefer:emailPrefer, phonePrefer:phonePrefer)
                        WantActivityData.activityList.append(wantActivity)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    self.tableView.hideLoadingFooter()
                    self.refreshController.endRefreshing()
                    self.currentPage = self.currentPage + 1
                })
                
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    self.tableView.hideLoadingFooter()
                    self.refreshController.endRefreshing()
                    WantAmplitude.sharedInstance.exception_event(exception: json.rawString()!)
                })
            }
        } catch {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.tableView.hideLoadingFooter()
                self.refreshController.endRefreshing()
                WantAmplitude.sharedInstance.exception_event(exception: "exception")
            })
        }
    }
    
    @IBAction func openFilterController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup =  storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController
        
        popup?.modalPresentationStyle = .currentContext
        popup?.modalTransitionStyle = .coverVertical
        popup?.filterApplyDelegate = self
        self.present(popup!, animated:true, completion: nil)
    }
    
    @IBAction func openSearchController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup =  storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        popup?.searchApplyDelegate = self
        popup?.modalPresentationStyle = .currentContext
        popup?.modalTransitionStyle = .coverVertical
        self.present(popup!, animated:true, completion: nil)
    }
    
    func appyleFilter() {
        self.locationLabel.text = FilterData.sharedInstance.city  + ", " + FilterData.sharedInstance.country
        self.collectionView.reloadData()
        currentPage = 0
        type = 5
        getNextPage()
    }
    
    func appyleSearch(keyword:String)
    {
        currentPage = 0
        getNextPage(search: keyword)
    }
    
    func logoutFromMainView(){
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.currentPage = 0
            FBSDKLoginManager().logOut()
            User.sharedInstance.clearAllData()
            WantActivityData.activityList.removeAll()
            self.loginViewDelegate?.checkFacebookButton()
            self.navigationController?.popViewController(animated: true)
        })
       
    }
    
    func updateLocation(){
        self.locationLabel.text = User.sharedInstance.city  + ", " + User.sharedInstance.country
    }
}

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView()
        loadingFooter.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.white;
        loadingFooter.color = UIColor(red: 20/255, green: 141/255, blue: 210/255, alpha: 1)
        loadingFooter.frame.size.height = 50
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 50
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
    
}
