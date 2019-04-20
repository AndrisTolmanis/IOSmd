//
//  ViewController.swift
//  MDapp
//
//  Created by Andris Tolmanis on 13/04/2019.
//  Copyright © 2019 Andris Tolmanis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnGoToMD2: UIButton!
    @IBOutlet weak var btnGoToMD3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGoToMD2.setTitle("Mājasdarbs 2", for: .normal)
        btnGoToMD3.setTitle("Mājasdarbs 3", for: .normal)
    }


}


