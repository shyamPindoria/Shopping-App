//
//  ListViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 9/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class ListViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    let model = SingletonManager.model
    
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductViewController
        
        let product = model.products[indexPath!.row]
        
        detailView.productItem = product
        detailView.originalPrice = product.price
        
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get an instancer of the prototype Cell we created
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        // Set the image in the cell
        cell.imageView.image = model.products[indexPath.row].image
        
        // Set the text in the cell
        cell.label.text = model.products[indexPath.row].name
        
        // Return the cell
        return cell
    }

    
}
