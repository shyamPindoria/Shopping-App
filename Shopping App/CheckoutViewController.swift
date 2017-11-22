//
//  CheckoutViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 22/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class CheckoutViewController: DetailViewController {
    
    @IBOutlet var cardNumber: UITextField!
    @IBOutlet var cardExpiryMonth: UITextField!
    @IBOutlet var cardExpiryYear: UITextField!
    @IBOutlet var cardCvv: UITextField!
    
    @IBOutlet var pickerPickupPoint: UIPickerView!
    
    @IBOutlet var tableViewOrderDetails: UITableView!
    
    @IBOutlet var labelTotalPrice: UILabel!
    
    var model = SingletonManager.model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCheckout()
    }
    
    func configureCheckout() {
        
    }
    
    @IBAction func payNow(_ sender: Any) {
        
    }
    
    
}
