//
//  FilterViewController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 26.11.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

public protocol FilterApplyDelegate: class {
    
    func appyleFilter()
}
class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectMultipleCategoryDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tempFilterData = FilterData()
    weak var filterApplyDelegate: FilterApplyDelegate? = nil
    var horizontalScrollView:ASHorizontalScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initFilters()
        self.designTableView()
    }
    
    private func initFilters(){
        tempFilterData.maxPrice = FilterData.sharedInstance.maxPrice
        tempFilterData.minPrice = FilterData.sharedInstance.minPrice
        tempFilterData.dateOption = FilterData.sharedInstance.dateOption
        tempFilterData.categories = FilterData.sharedInstance.categories
        if FilterData.sharedInstance.city == nil{
           tempFilterData.city = User.sharedInstance.city
           FilterData.sharedInstance.city = User.sharedInstance.city
        }
        else{
          tempFilterData.city = FilterData.sharedInstance.city
        }
        if FilterData.sharedInstance.country == nil{
            tempFilterData.country = User.sharedInstance.country
            FilterData.sharedInstance.country = User.sharedInstance.country
        }
        else{
            tempFilterData.country = FilterData.sharedInstance.country
        }
        FilterData.sharedInstance.saveFilterData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func designTableView(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        if index == 0 {
            let cell:FilterCityCell = tableView.dequeueReusableCell(withIdentifier: "FilterCityCell") as! FilterCityCell
            cell.cellLabel.text = "LOCATION"
            cell.cellButton.setTitle(tempFilterData.city + ", " +  tempFilterData.country, for: UIControlState())
            cell.controller = self
            return cell
        }
        else if index == 1 {
            let cell:FilterPriceCell = tableView.dequeueReusableCell(withIdentifier: "FilterPriceCell") as! FilterPriceCell
            cell.controller = self
            cell.minText.text = String(tempFilterData.minPrice)
            cell.maxText.text = String(tempFilterData.maxPrice)
            return cell
        }
        else if index == 2 {
            let cell:FilterDateCell = tableView.dequeueReusableCell(withIdentifier: "FilterDateCell") as! FilterDateCell
            cell.controller = self
            cell.initTableCell()
            return cell
        }
        else if index == 3 {
            let cell:FilterCategoryCell = tableView.dequeueReusableCell(withIdentifier: "FilterCategoryCell") as! FilterCategoryCell
            horizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 8, y: 4, width: 340, height: 32))
            
            horizontalScrollView.marginSettings_320 = MarginSettings(leftMargin: 1, miniMarginBetweenItems: 1, miniAppearWidthOfLastItem: 20)
            //for iPhone 4s and lower versions in landscape
            horizontalScrollView.marginSettings_480 = MarginSettings(leftMargin: 1, miniMarginBetweenItems: 1, miniAppearWidthOfLastItem: 20)
            // for iPhone 6 plus and 6s plus in portrait
            horizontalScrollView.marginSettings_414 = MarginSettings(leftMargin: 1, miniMarginBetweenItems: 1, miniAppearWidthOfLastItem: 20)
            // for iPhone 6 plus and 6s plus in landscape
            horizontalScrollView.marginSettings_736 = MarginSettings(leftMargin: 1, miniMarginBetweenItems: 1, miniAppearWidthOfLastItem: 30)
            //for all other screen sizes that doesn't set here, it would use defaultMarginSettings instead
            horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 1, miniMarginBetweenItems: 1, miniAppearWidthOfLastItem: 20)
            
            horizontalScrollView.uniformItemSize = CGSize(width: 60, height: 32)
            //this must be called after changing any size or margin property of this class to get acurrate margin
            horizontalScrollView.setItemsMarginOnce()
            cell.cellView.addSubview(horizontalScrollView)
            for i in 0 ..< tempFilterData.categories.count{
                if tempFilterData.categories[i] == true{
                    let category = CategoryData.sharedInstance.categoryList[i + 1]
                    addItem(text: (category?.name)!)
                }
            }
            cell.controller = self
            return cell
        }
        return UITableViewCell()
    }
    
    private func addItem(text:String){
        let title = UILabel(frame: CGRect.zero)
        title.text = text.trim() + ", "
        title.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        title.textColor = UIColor(red: 20/255, green: 141/255, blue: 211/255, alpha: 1)
        title.textAlignment = .left
        title.layoutIfNeeded()
        title.sizeToFit()
        horizontalScrollView.addItemSize(title, width: title.intrinsicContentSize.width)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height :CGFloat = 0.0
        let index = indexPath.item
        if index == 0 {
            height = CGFloat(84.0)
        }
        else if index == 1 {
            height = CGFloat(84.0)
        }
        else if index == 2 {
            height = CGFloat(190.0)
        }
        else{
            height = CGFloat(84.0)
        }
        return height
    }
    
    @IBAction func dismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleApplyFilter(_ sender: Any) {
        FilterData.sharedInstance.minPrice = tempFilterData.minPrice
        FilterData.sharedInstance.maxPrice = tempFilterData.maxPrice
        FilterData.sharedInstance.dateOption = tempFilterData.dateOption
        FilterData.sharedInstance.categories = tempFilterData.categories
        FilterData.sharedInstance.city = tempFilterData.city
        FilterData.sharedInstance.country = tempFilterData.country
        FilterData.sharedInstance.saveFilterData()
        self.dismiss(animated: true, completion: nil)
        filterApplyDelegate?.appyleFilter()
    }
    
    func selectMultipleCategory(_  categories: [Bool]){
        self.tempFilterData.categories = categories
        horizontalScrollView.removeFromSuperview()
        horizontalScrollView = nil
        tableView.reloadData()
    }
}
