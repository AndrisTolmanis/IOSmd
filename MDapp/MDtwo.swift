//
//  MDtwo.swift
//  MDapp
//
//  Created by Andris Tolmanis on 13/04/2019.
//  Copyright © 2019 Andris Tolmanis. All rights reserved.
//

import UIKit

class MDtwo: UIViewController{
    @IBOutlet weak var lblTi: UILabel!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var btnRavemode: UIButton!
    // Initialize the LIGHTS!!!!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var redView: UIView!
    // Initializes date formatter for use later
    let timeFormatter = DateFormatter()
    // Is it day?
    var isDay:Bool = true
    // Initializes timer and time counter
    var timer = Timer()
    var counter:Int = 0;
    // Is it party time?
    var ravetime:Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Make the views round
        greenView.layer.cornerRadius = greenView.frame.size.width/2
        yellowView.layer.cornerRadius = yellowView.frame.size.width/2
        redView.layer.cornerRadius = redView.frame.size.width/2
        // Set minimum and maximum values for the time picker
        timeFormatter.dateFormat =  "HH:mm"
        pickerTime.minimumDate = timeFormatter.date(from: "6:01")
        pickerTime.maximumDate = timeFormatter.date(from: "23:59")
        workLights()
        btnRavemode.setTitle("Enable rave mode", for: .normal)
    }
    // Fires every time the value in date time picker is changed
    @IBAction func pickerTimeChanged(_ sender: UIDatePicker) {
        timeFormatter.timeStyle = DateFormatter.Style.short
        workLights()
    }
    // Fires when ravemode button is pressed
    @IBAction func ravemodeClick(_ sender: UIButton) {
        ravemode()
    }
    // Makes the yellow light blink every second
    @objc func processTimer() {
        switch(ravetime){
        case(true):
            self.view.backgroundColor = .random()
            self.greenView.backgroundColor = .random()
            self.yellowView.backgroundColor = .random()
            self.redView.backgroundColor = .random()
            self.btnRavemode.setTitleColor(.random(), for: .normal)
            self.lblTi.textColor = .random()
            self.pickerTime.setValue(UIColor.random(), forKeyPath: "textColor")
        case(false):
            counter+=1
            if(counter%2 == 0){
                setYellow()
            }else{
                setWhite()
            }
        }
        
    }
    // Starts the timer
    func startTimer(val:Double){
        timer = Timer.scheduledTimer(timeInterval: val, target: self, selector: #selector(MDtwo.processTimer), userInfo: nil, repeats: true)
    }
    // Kills the timer - stops the blinking
    @IBAction func killTimer() {
        timer.invalidate()
    }
    // Sets all lights to white
    func setWhite(){
        greenView.backgroundColor = UIColor.white
        yellowView.backgroundColor = UIColor.white
        redView.backgroundColor = UIColor.white
    }
    // Sets all lights to yellow
    func setYellow(){
        greenView.backgroundColor = UIColor.yellow
        yellowView.backgroundColor = UIColor.yellow
        redView.backgroundColor = UIColor.yellow
    }
    // Makes the lights doo stuff
    func workLights(){
        if(ravetime != true){
            let iTime: Int = Int(pickerTime.countDownDuration / 60)
            // Decides if it is day or night 6 to 21 is day anything else is night
            if(iTime < 359 || iTime > 1260){
                isDay = false
            }else{
                isDay = true
            }
            switch (isDay){
            case (true):
                // If it is day normal mode is enabled
                killTimer()
                setWhite()
                let number: Int = iTime % 7
                if (number == 4 || number == 5) {
                    setWhite()
                    greenView.backgroundColor = UIColor.green
                } else if (number == 3 || number == 6) {
                    setWhite()
                    yellowView.backgroundColor = UIColor.yellow
                } else if(number == 0 || number == 1 || number == 2){
                    setWhite()
                    redView.backgroundColor = UIColor.red
                }
            case (false):
                // If it is night - the yellow light start blinking
                killTimer()
                setWhite()
                startTimer(val: 1)
            }
        }
    }
    // Party functions
    func ravemode(){
        switch(ravetime){
        case(true):
            ravetime = false
            killTimer()
            btnRavemode.setTitle("Enable rave mode", for: .normal)
            self.view.backgroundColor = UIColor.white
            self.btnRavemode.setTitleColor(UIColor.blue, for: .normal)
            self.lblTi.textColor = UIColor.black
            self.pickerTime.setValue(UIColor.black, forKeyPath: "textColor")
            setWhite()
            workLights()
        case(false):
            ravetime = true
            btnRavemode.setTitle("Disable rave mode", for: .normal)
            killTimer()
            startTimer(val: 0.3)
        }
        
    }
}

// Some functions i found online that makes random colours
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
