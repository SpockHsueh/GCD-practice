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
    
    var semaphore = DispatchSemaphore(value: 1)
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func semaphore(_ sender: Any) {
        cleanDisplay()
        Semaphore()
    }
    
    
    @IBAction func group(_ sender: Any) {
        cleanDisplay()
        group()
    }
    
    func Semaphore() {
        
        let loadingQueue = DispatchQueue.global()
        
        loadingQueue.async {
            self.semaphore.wait()
            self.client.getNameData { (data, error) in
                if error == nil {
                    self.label1.text = data!
                    print("--------------")
                    print(data!)
                    self.semaphore.signal()
                }
            }
            
            self.semaphore.wait()
            self.client.getAddressData { (data, error) in
                self.label2.text = data!
                print(data!)
                self.semaphore.signal()
            }
            
            self.semaphore.wait()
            self.client.getHeadData { (data, error) in
                self.label3.text = data!
                print(data!)
                print("--------------")
                self.semaphore.signal()
            }
        }
    }
    
    func group() {
        print("--------------")
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
            print("--------------")
        }
    }
    
    func display() {
        print("Display Data")
        self.label1.text = self.name
        self.label2.text = self.address
        self.label3.text = self.head
    }
    
    func cleanDisplay() {
        self.label1.text = "Label1"
        self.label2.text = "Label2"
        self.label3.text = "Label3"
    }
    
}

