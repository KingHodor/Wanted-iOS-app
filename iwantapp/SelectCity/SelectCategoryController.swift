//
//  SelectCategoryController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 2.11.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

protocol SelectCategoryDelegate: class {
    func selectCategory(_  categoryId: Int)
}

class SelectCategoryController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var selectCategoryDelegate: SelectCategoryDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.desingViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func desingViewController(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryData.sharedInstance.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCategoryCell",
                                                      for: indexPath as IndexPath) as? SelectCategoryCell
        let category = CategoryData.sharedInstance.categoryList[indexPath.item + 1]
        cell?.iconImgView.image = category?.image
        cell?.titleText.text = category?.name
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item + 1
        selectCategoryDelegate?.selectCategory(index)
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.invalidateLayout()
            return CGSize(width: ((self.view.frame.width/2) - 15), height: 70.0)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.invalidateLayout()
            return CGSize(width: ((self.view.frame.width/3) - 15), height: 70.0)
        }
        else{
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.invalidateLayout()
            return CGSize(width: ((self.view.frame.width/2) - 15), height: 70.0)
        }
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
