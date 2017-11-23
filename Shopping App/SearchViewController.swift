//
//  SearchViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 23/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    
    var resultsController = UITableViewController()
    
    var filteredProducts = [Product]()
    
    let model = SingletonManager.model
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.filteredProducts = self.model.products.filter({ (product: Product) -> Bool in
            if product.name.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                return true
            } else {
                return false
            }
        })
        
        self.resultsController.tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var product = Product()
        
        if sender as! UITableView == self.tableView {
            let indexPath = self.tableView.indexPathForSelectedRow
            product = self.model.products[indexPath!.row]
        }
        else {
            let indexPath = self.resultsController.tableView.indexPathForSelectedRow
            product = self.filteredProducts[indexPath!.row]
        }
        
        
        
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductViewController
        
        
        
        detailView.productItem = product
        detailView.originalPrice = product.price
 
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return self.model.products.count
        } else {
            return self.filteredProducts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if tableView == self.tableView {
            cell.textLabel?.text = self.model.products[indexPath.row].name
        } else {
            cell.textLabel?.text = self.filteredProducts[indexPath.row].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Product", sender: tableView)
        
        print("didselect")
    }
    
}
