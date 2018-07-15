//
//  ProductViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 14/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class ProductViewController: DetailViewController {
    
    let model = SingletonManager.model
    
    @IBOutlet var titleBar: UINavigationItem!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productDescription: UILabel!
    @IBOutlet var productCategory: UILabel!
    
    @IBOutlet var quantityLabel: UILabel!
    
    @IBOutlet var finishSegment: UISegmentedControl!
    @IBOutlet var materialSegment: UISegmentedControl!
    
    
    var productItem: Product?
    var originalPrice: Double?
    var subTotalPrice: Double = 0.0
    var totalPrice: Double = 0.0
    var quantity: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let product = self.productItem, let price = originalPrice{
            self.configureView(for: product, with: price)
            subTotalPrice = price
            totalPrice = price
        }
    }
    
    func configureView(for product: Product, with price: Double) {
        self.titleBar.title = product.name
        self.productImage.image = product.image
        self.productName.text = product.name
        self.productPrice.text = "$" + String(format: "%.2f", price)
        self.productDescription.text = product.details
        self.productCategory.text = "Category: " + product.category
        self.quantityLabel.text = "Quantity: " + String(quantity)
    }
    
    @IBAction func finishMaterialChanged(_ sender: UISegmentedControl) {
        
        if var price = originalPrice {
            
        if finishSegment.selectedSegmentIndex == 1 {
            price += originalPrice! * 0.55
        }
        if materialSegment.selectedSegmentIndex == 1 {
            price += originalPrice! * 0.10
        }
        
        
        self.subTotalPrice = price
        }
        updateTotalPrice()
    }
    
    @IBAction func quantityStepper(_ sender: UIStepper) {
            
        quantity = Int(sender.value)
        updateTotalPrice()
        
    }
    
    func updateTotalPrice() {
        
        if let product = self.productItem {
            totalPrice = subTotalPrice * Double(quantity)
            configureView(for: product, with: totalPrice)
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if let product = self.productItem {
            model.addToCart(product: product, quantity: Double(quantity), finish: Double(finishSegment.selectedSegmentIndex), material: Double(materialSegment.selectedSegmentIndex), totalPrice: totalPrice)
        }
        
        showAlertMsg("Successful", message: "Item added to cart.", time: 1)
        
    }
    
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0.0
    var baseMessage: String?

    
    func showAlertMsg(_ title: String, message: String, time: Double) {
        
        guard (self.alertController == nil) else {
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    @objc func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message)
    }
    
}
