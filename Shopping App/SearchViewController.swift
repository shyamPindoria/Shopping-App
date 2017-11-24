//
//  SearchViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 23/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class SearchViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var filteredProducts = [Product]()
    
    var isSearching = false
    
    let model = SingletonManager.model
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.searchBar.delegate = self
        
    }
    
    func updateSearchResults() {
        
        self.filteredProducts = self.model.products.filter({ (product: Product) -> Bool in
            if product.name.lowercased().contains(self.searchBar.text!.lowercased()) {
                return true
            } else {
                return false
            }
        })
        
        self.collectionView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var product = Product()
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        if self.isSearching {
            product = self.filteredProducts[indexPath!.row]
        }
        else {
            product = self.model.products[indexPath!.row]
        }
        
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductViewController
        
        detailView.productItem = product
        detailView.originalPrice = product.price
 
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.isSearching {
            return self.filteredProducts.count
        } else {
            return self.model.products.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        if self.isSearching {
            cell.label.text = self.filteredProducts[indexPath.row].name
            cell.imageView.image = self.filteredProducts[indexPath.row].image
        } else {
            cell.label.text = self.model.products[indexPath.row].name
            cell.imageView.image = self.model.products[indexPath.row].image
        }
        
        return cell
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            self.isSearching = false
            self.collectionView.reloadData()
            
        } else {
            
            self.isSearching = true
            self.updateSearchResults()
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.view.endEditing(true)
        self.isSearching = false
        self.collectionView.reloadData()
        
    }
    
    
    
}
