//
//  ListViewController.swift
//  Shopping App
//
//  Created by Shyam Pindoria on 9/11/17.
//  Copyright © 2017 Shyam Pindoria. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    let model = SingletonManager.model
    
    @IBOutlet var label: UILabel!
    
    func configureView() {
        label.text = model.products[0].details
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    
}
