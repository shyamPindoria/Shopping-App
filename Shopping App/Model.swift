//
//  Model.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 8/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit
import CoreData

class Model {
    
    var segueArray = [String]()
    var seguesDictionary = Dictionary<String, UIImage>()
    
    var products = [Product]()
    var storedProducts = [NSManagedObject]()
    
    var cart = [Product]()
    
    init() {
        
        segueArray.append("Home")
        segueArray.append("List")
        segueArray.append("Search")
        segueArray.append("Cart")
        segueArray.append("Finder")
        segueArray.append("Checkout")
        
        seguesDictionary["Home"] = UIImage(named: "home")
        seguesDictionary["List"] = UIImage(named: "list")
        seguesDictionary["Search"] = UIImage(named: "search")
        seguesDictionary["Cart"] = UIImage(named: "cart")
        seguesDictionary["Finder"] = UIImage(named: "finder")
        seguesDictionary["Checkout"] = UIImage(named: "checkout")
        
        self.loadProducts()
        self.refreshProducts()
        print("Items in products array: \(products.count)")
    }
    
    func loadProducts() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            storedProducts = results as! [NSManagedObject]
            
            if storedProducts.count > 0 {
                for index in 0...storedProducts.count - 1 {
                    
                    let binaryData = storedProducts[index].value(forKey: "image") as! Data
                    let image = UIImage(data: binaryData)
                    
                    let name = storedProducts[index].value(forKey: "name") as! String
                    let price = storedProducts[index].value(forKey: "price") as! Double
                    let details = storedProducts[index].value(forKey: "details") as! String
                    let category = storedProducts[index].value(forKey: "category") as! String
                    let uid = storedProducts[index].value(forKey: "uid") as! String
                    
                    let loadedProduct = Product(name: name, price: price, image: image!, details: details, category: category, uid: uid)
                    
                    products.append(loadedProduct)
                    
                }
            }
        }
        catch let error as NSError
        {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    
    func refreshProducts() {
        
        let url = NSURL(string: "http://partiklezoo.com/3dprinting/")
        let config = URLSessionConfiguration.default
        config.isDiscretionary = true
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url! as URL, completionHandler:
        {(data, response, error) in
            do {
                let json = try JSON(data: data!)
                
                for count in 0...json.count - 1
                {
                    let newProduct = Product()
                    newProduct.name = json[count]["name"].string
                    newProduct.price = Double(json[count]["price"].string!)
                    newProduct.details = json[count]["description"].string
                    newProduct.category = json[count]["category"].string
                    newProduct.uid = json[count]["uid"].string
                    
                    print(count)
                    
                    let imgURL = json[count]["image"].string!
                    
                    self.addItemToList(newProduct, imageURL: imgURL)
                }
            }
            catch let error as NSError
            {
                print("Could not convert. \(error), \(error.userInfo)")
            }
        })
        task.resume()
    }
    
    func checkForProduct(_ searchItem: Product) -> Int {
        var targetIndex = -1
        
        if products.count > 0 {
            for index in 0...products.count - 1 {
                if products[index].uid == searchItem.uid {
                    targetIndex = index
                }
            }
            
        }
        
        return targetIndex
    }
    
    func addItemToList(_ newProduct: Product!, imageURL: String) {
        
        if checkForProduct(newProduct) == -1 {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let picture = UIImageJPEGRepresentation(loadImage(imageURL), 1)
            let entity = NSEntityDescription.entity(forEntityName: "Products", in: managedContext)
            let productToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            productToAdd.setValue(newProduct.category, forKey: "category")
            productToAdd.setValue(newProduct.details, forKey: "details")
            productToAdd.setValue(picture, forKey: "image")
            productToAdd.setValue(newProduct.name, forKey: "name")
            productToAdd.setValue(newProduct.price, forKey: "price")
            productToAdd.setValue(newProduct.uid, forKey: "uid")
            
            do
            {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            storedProducts.append(productToAdd)
            newProduct.image = UIImage(data: picture!)
            products.append(newProduct)

        }
    }
    
    func loadImage(_ imageURL: String) -> UIImage {
        var image: UIImage!
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOf: url as URL) {
                image = UIImage(data: data as Data)
            }
        }
        return image!
    }
}
