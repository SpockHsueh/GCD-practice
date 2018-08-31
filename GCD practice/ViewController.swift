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
    
    let client = APIClient(configuration: .default)
    
    var semaphore = DispatchSemaphore(value: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        Semaphore()
    }
    
    func Semaphore() {
        for i in 1...100{
            
            self.semaphore.wait()
            self.client.getNameData { (data, error) in
                self.label1.text = data!
                print(self.label1.text)
            }
            self.semaphore.signal()
            
            self.semaphore.wait()
            self.client.getAddressData { (data, error) in
                self.label2.text = data!
                self.semaphore.signal()
                print(self.label2.text)
            }
            self.semaphore.signal()
            
            self.semaphore.wait()
            self.client.getHeadData { (data, error) in
                self.label3.text = data!
                self.semaphore.signal()
                print(self.label3.text)
            }
            self.semaphore.signal()
        }
  
    }
}

