//
//  Model.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 8/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class Model: NSObject, CLLocationManagerDelegate {
    
    var segueArray = [String]()
    var seguesDictionary = Dictionary<String, UIImage>()
    
    var products = [Product]()
    var storedProducts = [NSManagedObject]()
    
    var cart = [[Double]]()
    var storedCart = [NSManagedObject]()
    
    var pickUpLocations = [[String: String]]()
    
    let locationManager = CLLocationManager()
    
    override init() {
        
        super.init()
        
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
        self.loadCart()
        self.configureLocManager()
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
            
            let json = JSON(data: data!)
            
            for count in 0...json.count - 1
            {
                let newProduct = Product()
                newProduct.name = json[count]["name"].string
                newProduct.price = Double(json[count]["price"].string!)
                newProduct.details = json[count]["description"].string
                newProduct.category = json[count]["category"].string
                newProduct.uid = json[count]["uid"].string
                
                let imgURL = json[count]["image"].string!
                
                self.addItemToList(newProduct, imageURL: imgURL)
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
    
    func loadCart() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            storedCart = results as! [NSManagedObject]
            
            if storedCart.count > 0 {
                for index in 0...storedCart.count - 1 {
                    
                    let product = storedCart[index].value(forKey: "product") as! Double
                    let quantity = storedCart[index].value(forKey: "quantity") as! Double
                    let finish = storedCart[index].value(forKey: "finish") as! Double
                    let material = storedCart[index].value(forKey: "material") as! Double
                    let totalPrice = storedCart[index].value(forKey: "total") as! Double
                    
                    let temp = [product, quantity, finish, material, totalPrice]
                    
                    cart.append(temp)
                    
                }
            }
        }
        catch let error as NSError
        {
            print("Could not load. \(error), \(error.userInfo)")
        }
        
    }
    
    func addToCart(product: Product, quantity: Double, finish: Double, material: Double, totalPrice: Double) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: managedContext)
        let productToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
        productToAdd.setValue(checkForProduct(product), forKey: "product")
        productToAdd.setValue(quantity, forKey: "quantity")
        productToAdd.setValue(finish, forKey: "finish")
        productToAdd.setValue(material, forKey: "material")
        productToAdd.setValue(totalPrice, forKey: "total")
        
        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        let temp = [Double(checkForProduct(product)), quantity, finish, material, totalPrice]
        
        storedCart.append(productToAdd)
        cart.append(temp)
        
    }
    
    func clearCart() {
        
        cart.removeAll()
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do
        {
            try managedContext.execute(request)
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func calculateCartTotal() -> Double{
        var total = 0.0
        if self.cart.count > 0 {
            for index in 0...self.cart.count - 1 {
                total += cart[index][4]
            }
        }
        return total
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
    
    func configureLocManager(){
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            refreshPickUpLocations()
        }
        
    }
    
    func refreshPickUpLocations() {
        
        self.pickUpLocations.removeAll()
        
        var locValue = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        if let currentLoc = locationManager.location?.coordinate {
            locValue = currentLoc
        }
        
        let url = NSURL(string: "http://partiklezoo.com/3dprinting/?action=locations&coord1=\(locValue.latitude)&coord2=\(locValue.longitude)")
        let config = URLSessionConfiguration.default
        config.isDiscretionary = true
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url! as URL, completionHandler:
        {(data, response, error) in
            
            let json = JSON(data: data!)
            
            for count in 0...json.count - 1
            {
                var location = [String: String]()
                
                location["street"] = json[count]["street"].string
                location["suburb"] = json[count]["suburb"].string
                location["postcode"] = json[count]["postcode"].string
                location["state"] = json[count]["state"].string
                location["countrycode"] = json[count]["countrycode"].string
                location["uid"] = json[count]["uid"].string
                
                self.pickUpLocations.append(location)

            }
            
        })
        task.resume()
    }
    
    func purchase(product: Product, quantity: Int, total: Double, material: String, painting: String) -> Bool{
        
        var success = false
        
        let group = DispatchGroup()
        group.enter()
        
        var urlString = "http://partiklezoo.com/3dprinting/?action=purchase&"
        urlString += product.uid + "=" + String(quantity)
        urlString += "&total=" + String(total)
        urlString += "&material=" + material
        urlString += "&painting=" + painting
        
        let url = NSURL(string: urlString)
        
        print(url?.absoluteString ?? "URL error")
        
        let config = URLSessionConfiguration.default
        config.isDiscretionary = true
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url! as URL, completionHandler:
        {(data, response, error) in
            
            let json = JSON(data: data!)
            
            let successString = json["success"].string
            
            print (json)
            
            if successString == "true" {
                success = true
            }
            group.leave()
            
        })
        task.resume()
        
        group.wait()
        
        return success
    }
    
    
}
