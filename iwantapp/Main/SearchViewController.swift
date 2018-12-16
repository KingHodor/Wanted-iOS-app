//
//  SearchViewController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 5.12.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

public protocol SearchApplyDelegate: class {
    
    func appyleSearch(keyword:String)
}

class SearchViewController: UIViewController, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var filteredArray = [SearchKeyword]()
    var shouldShowSearchResults : Bool = false
    weak var searchApplyDelegate: SearchApplyDelegate? = nil
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
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
        if searchText == "" {
            shouldShowSearchResults = false
        }
        else
        {
            filteredArray = SearchKeywordData.sharedInstance.keywords.filter({ (keyword) -> Bool in
                let searchKeyword: NSString = keyword.keyword as NSString
                
                return (searchKeyword.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            shouldShowSearchResults = true
            
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height :CGFloat = 0.0
        height = CGFloat(64)
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return 0//SearchKeywordData.sharedInstance.keywords.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = filteredArray[indexPath.item]
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        searchApplyDelegate?.appyleSearch(keyword: keyword.keyword)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = self.tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as? SearchTableCell
        
        if shouldShowSearchResults {
            let keyword = filteredArray[indexPath.item]
            let category = CategoryData.sharedInstance.categoryList[keyword.category]
            tableCell?.iconImgView.image = category?.c_image
            tableCell?.searchText.text = keyword.keyword
          
        }
        else {
            let keyword = SearchKeywordData.sharedInstance.keywords[indexPath.item]
            let category = CategoryData.sharedInstance.categoryList[keyword.category]
            tableCell?.iconImgView.image = category?.c_image
            tableCell?.searchText.text = keyword.keyword
        }
        
        return tableCell!
    }

}
