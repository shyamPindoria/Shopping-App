//
//  SearchViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 23/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var filteredProducts = [Product]()
    
    var isSearching = false
    
    let model = SingletonManager.model
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
    func updateSearchResults() {
        
        self.filteredProducts = self.model.products.filter({ (product: Product) -> Bool in
            if product.name.lowercased().contains(self.searchBar.text!.lowercased()) {
                return true
            } else {
                return false
            }
        })
        
        self.tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var product = Product()
        let indexPath = sender as! IndexPath
        
        if self.isSearching {
            product = self.filteredProducts[indexPath.row]
        }
        else {
            product = self.model.products[indexPath.row]
        }
        
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductViewController
        
        detailView.productItem = product
        detailView.originalPrice = product.price
 
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearching {
            return self.filteredProducts.count
        } else {
            return self.model.products.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if self.isSearching {
            cell.textLabel?.text = self.filteredProducts[indexPath.row].name
        } else {
            cell.textLabel?.text = self.model.products[indexPath.row].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "Product", sender: indexPath)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            self.isSearching = false
            self.tableView.reloadData()
            
        } else {
            
            self.isSearching = true
            self.updateSearchResults()
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.tableView.reloadData()
    }
    
}
