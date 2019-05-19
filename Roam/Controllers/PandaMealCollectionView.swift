//
//  PandaMealCollectionView.swift
//  Roam
//
//  Created by Kay Lab on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PandaMealCollectionView: UICollectionViewController {
    
    let mealNames: [String] = ["bowl", "plate", "biggerPlate", "familyFeast", "kidsMeal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // what you use to configure the layout of MovieGrid
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumLineSpacing * 1) / 2
        
        layout.itemSize = CGSize(width: width , height: width)
        //let length = view.frame.size.height
    }



    // MARK: UICollectionViewDataSource




    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath) as! MealCell
        cell.mealName.text = mealNames[indexPath.row]
        cell.mealImage.image = UIImage(named: mealNames[indexPath.row])
        
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate



}
