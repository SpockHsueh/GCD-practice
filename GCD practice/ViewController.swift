//
//  ViewController.swift
//  GCD practice
//
//  Created by Spoke on 2018/8/31.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var name: String?
    var address: String?
    var head: String?
    
    let client = APIClient(configuration: .default)
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        group()
    }
    
    func group() {
        
        print("Dowloading Data")
        dispatchGroup.enter()
        self.client.getNameData { (data, error) in
            self.name = data!
            print(data!)
            self.dispatchGroup.leave()
        }
    
        dispatchGroup.enter()
        self.client.getAddressData { (data, error) in
            self.address = data!
            print(data!)
            self.dispatchGroup.leave()
        }
    
        dispatchGroup.enter()
        self.client.getHeadData { (data, error) in
            self.head = data!
            print(data!)
            self.dispatchGroup.leave()
        }
    
        dispatchGroup.notify(queue: .main) {
           self.display()
        }
    }
    
    func display() {
        print("Display Data")
        self.label1.text = self.name
        self.label2.text = self.address
        self.label3.text = self.head
    }
}

