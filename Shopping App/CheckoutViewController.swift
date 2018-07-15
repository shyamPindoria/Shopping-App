//
//  CheckoutViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 22/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class CheckoutViewController: DetailViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        
        self.tableViewOrderDetails.dataSource = self
        self.tableViewOrderDetails.delegate = self
        
        self.pickerPickupPoint.dataSource = self
        self.pickerPickupPoint.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    func configureCheckout() {
        
        pickerPickupPoint.selectedRow(inComponent: 0)
        
        labelTotalPrice.text = "$" + String(format: "%.2f", model.calculateCartTotal())
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = model.products[Int(model.cart[indexPath.row][0])].name
        cell.detailTextLabel?.text = String(Int(model.cart[indexPath.row][1])) + " x $" + String(format: "%.2f", model.cart[indexPath.row][4])
        
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.pickUpLocations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.pickUpLocations[row]["street"]! + ", " + model.pickUpLocations[row]["suburb"]!
    }
    
    @IBAction func payNow(_ sender: Any) {
        
        var error = ""
        
        
        if self.model.cart.count == 0 {
            error = "Your cart is empty."
        }
        else if (self.cardNumber.text?.isEmpty)! {
            error = "Please enter your card number."
        }
        else if (self.cardExpiryMonth.text?.isEmpty)! {
            error = "Please enter the expiry month of your card."
        }
        else if (self.cardExpiryYear.text?.isEmpty)! {
            error = "Please enter the expiry year of your card."
        }
        else if (self.cardCvv.text?.isEmpty)!{
            error = "Please enter the CVV number of your card."
        }
        
        
        
        if error.isEmpty {
            
            showAlertMsg("Confirm Purchase", message: "Pay " + labelTotalPrice.text!, style: UIAlertControllerStyle.actionSheet)
            
        }
        else {
            showAlertMsg("Error", message: error, style: UIAlertControllerStyle.alert)
        }
        
    }
    
    var alertController: UIAlertController?
    
    func showAlertMsg(_ title: String, message: String, style: UIAlertControllerStyle) {
        
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if style == UIAlertControllerStyle.actionSheet {
            alertController?.addAction(UIAlertAction(title: "Pay", style: .default, handler: { _ in
                self.checkout()
            }))
            
            alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        } else {
            alertController?.addAction(UIAlertAction(title: "Okay", style: .default))
        }
        
        self.present(self.alertController!, animated: true, completion: nil)
        
    }
    
    func checkout() {
        
        var success = true
        
        for count in 0...self.model.cart.count - 1 {
            
            let product = self.model.products[Int(self.model.cart[count][0])]
            let quantity = Int(self.model.cart[count][1])
            let total = self.model.cart[count][4]
            let material = self.model.cart[count][3] == 0.0 ? "pla" : "abs"
            let painting = self.model.cart[count][2] == 0.0 ? "false" : "true"
            
            
            let temp = self.model.purchase(product: product, quantity: quantity, total: total, material: material, painting: painting)
            
            if !temp {
                success = false
            }
            
        }
        
        if !success {
            let error = "Oops! Something went wrong. Please try again later."
            showAlertMsg("Error", message: error, style: UIAlertControllerStyle.alert)
            
        } else {
            print("Success! Checkout complete.")
            
            self.cardNumber.text = ""
            self.cardExpiryMonth.text = ""
            self.cardExpiryYear.text = ""
            self.cardCvv.text = ""
            
            self.labelTotalPrice.text = "$0.00"
            
            self.model.clearCart()
            self.tableViewOrderDetails.reloadData()
            
            self.performSegue(withIdentifier: "Thankyou", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let confirmationVc = (segue.destination as! UINavigationController).topViewController as! ConfirmationViewController
        
        confirmationVc.location = self.model.pickUpLocations[self.pickerPickupPoint.selectedRow(inComponent: 0)]
        
        
    }
    
    
}
