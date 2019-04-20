//
//  MDthreeAdd.swift
//  MDapp
//
//  Created by Andris Tolmanis on 20/04/2019.
//  Copyright © 2019 Andris Tolmanis. All rights reserved.
//

import UIKit
import Firebase

class MDthreeAdd: UIViewController{
    var dbStuff: DatabaseReference!
    
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var textDesc: UITextField!
    @IBOutlet weak var textLat: UITextField!
    @IBOutlet weak var textLong: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbStuff = Database.database().reference()
    }
    @IBAction func btnSavePressed(_ sender: UIButton) {
        if let title = textTitle.text,
            let sub = textDesc.text,
            let lat = Double(textLat.text!),
            let long = Double(textLong.text!) {
            addData(title: title, sub: sub, lat: lat, long: long )
        }
        textTitle.text = ""
        textDesc.text = ""
        textLat.text = ""
        textLong.text = ""
    }
    
    
    func addData(title:String, sub:String, lat:Double, long:Double){
        dbStuff.child("locations").childByAutoId().setValue([ "title": title, "subtitle": sub, "lat": lat, "long": long, "show": true ])
    }
}
