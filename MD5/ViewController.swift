//
//  ViewController.swift
//  MD5
//
//  Created by BiaoShu on 2016/12/26.
//  Copyright © 2016年 BiaoShu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tempString = "abc"
        print(toHexString(bytes: md5(message: Array(tempString.utf8))))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

