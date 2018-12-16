//
//  WantDetailsController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 19.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class WantDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var wantActivity:WantActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designTableView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func designTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        if index == 0 {
            let cell:DetailsBasicCell = tableView.dequeueReusableCell(withIdentifier: "DetailsBasicCell") as! DetailsBasicCell
            cell.titleLabel.text = "S/HE WANTS"
            cell.descLabel.text = self.wantActivity.want
            return cell
        }
        else if index == 1 {
            let cell:DetailsBasicCell = tableView.dequeueReusableCell(withIdentifier: "DetailsBasicCell") as! DetailsBasicCell
            cell.titleLabel.text = "PRICE ABOUT"
            if wantActivity.minPrice != nil && wantActivity.maxPrice != nil && wantActivity.maxPrice != 0 && wantActivity.minPrice != 0{
              cell.descLabel.text = String(self.wantActivity.minPrice) + " - " + String(self.wantActivity.maxPrice) + " (USD)"
            }
            else{
                cell.descLabel.text = ""
            }
            
            return cell
        }
        else if index == 2 {
            let cell:DetailsCategoryCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCategoryCell") as! DetailsCategoryCell
            if let category = CategoryData.sharedInstance.categoryList[wantActivity.category]{
                cell.categoryName.text = category.name
            }
            return cell
        }
        else if index == 3 {
            let cell:DetailsBasicCell = tableView.dequeueReusableCell(withIdentifier: "DetailsBasicCell") as! DetailsBasicCell
            cell.titleLabel.text = "LOCATION"
            cell.descLabel.text = self.wantActivity.city + ", " + self.wantActivity.country
            return cell
        }
        else if index == 4 {
            let cell:DetailsBasicCell = tableView.dequeueReusableCell(withIdentifier: "DetailsBasicCell") as! DetailsBasicCell
            cell.titleLabel.text = "S/HE ALSO MENTIONED"
            cell.descLabel.text = self.wantActivity.descript
            return cell
        }
        else if index == 5 {
            let cell:DetailsReachCell = tableView.dequeueReusableCell(withIdentifier: "DetailsReachCell") as! DetailsReachCell
            cell.controller = self
            cell.email = wantActivity.email
            cell.phone = wantActivity.phone
            if wantActivity.emailPrefer == 1 && wantActivity.email != nil && wantActivity.email != ""{
                cell.emailButton.isEnabled = true
                cell.emailButton.alpha = 1.0
            }else{
                cell.emailButton.isEnabled = false
                cell.emailButton.alpha = 0.5
            }
            
            if wantActivity.phonePrefer == 1 && wantActivity.phone != nil && wantActivity.phone != ""{
                cell.phoneButton.isEnabled = true
                cell.phoneButton.alpha = 1.0
            }else{
                cell.phoneButton.isEnabled = false
                cell.phoneButton.alpha = 0.5
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height :CGFloat = 0.0
        if indexPath.item == 5 {
            height = CGFloat(208)
        }
        else{
            height = CGFloat(84)
        }
        return height
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
