//
//  Product.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 9/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class Product: NSObject {
    
    var name: String! = ""
    var price: Double! = 0
    var image: UIImage?
    var details: String! = ""
    var category: String! = ""
    var uid: String!
    
    override init() {
    }
    
    init(name: String, price: Double, image: UIImage, details: String, category: String, uid: String) {
        self.name = name
        self.price = price
        self.image = image
        self.details = details
        self.category = category
        self.uid = uid
    }
    
    init(name: String, price: Double, details: String, category: String, uid: String) {
        self.name = name
        self.price = price
        self.details = details
        self.category = category
        self.uid = uid
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let otherProduct = object as? Product {
            if self.name == otherProduct.name && self.price == otherProduct.price && self.image == otherProduct.image && self.details == otherProduct.details && self.category == otherProduct.category && self.uid == otherProduct.uid {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}


