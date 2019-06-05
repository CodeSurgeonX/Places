//
//  CategorySpecificViewController.swift
//  Places App
//
//  Created by Shashwat  on 05/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit



class CategorySpecificViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
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
    
}
