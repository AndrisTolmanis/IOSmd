//
//  MDthreeFilter.swift
//  MDapp
//
//  Created by Andris Tolmanis on 14/04/2019.
//  Copyright © 2019 Andris Tolmanis. All rights reserved.
//

import UIKit
import MapKit

class MDthreeFilter:UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var btnHide: UIButton!
    @IBOutlet weak var btnRange: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var locations = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func btnHidePressed(_ sender: Any) {
        for location in locations{
            if let su = location["subtitle"] as? String,
                var show = location["show"] as? Bool{
                if(su == ""){
                    show = false
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter", let vc = segue.destination as? MDthree{
            vc.locations = locations
        }
        
    }
    
}


