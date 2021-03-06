//
//  InterfaceController.swift
//  Carnivore WatchKit Extension
//
//  Created by IJke Botman on 15/01/2018.
//  Copyright © 2018 IJke Botman. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var timerButton: WKInterfaceButton!
    @IBOutlet var weightPicker: WKInterfacePicker!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var temperaturePicker: WKInterfacePicker!
    
    var ounces = 16
    var cookTemp = MeatTemperature.medium
    var timerRunning = false
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        var weightItems: [WKPickerItem] = []
        for number in 1...32 {
            let item = WKPickerItem()
            item.title = String(number)
            weightItems.append(item)
        }
        weightPicker.setItems(weightItems)
        weightPicker.setSelectedItemIndex(ounces - 1)
        
        var tempItems: [WKPickerItem] = []
        for item in 1...4 {
            let temperaturePickerItem = WKPickerItem()
            temperaturePickerItem.contentImage = WKImage(imageName: "temp-\(item)")
            tempItems.append(temperaturePickerItem)
        }
        temperaturePicker.setItems(tempItems)
        onTemperatureChanged(0)
    }
    
    override func interfaceOffsetDidScrollToTop() {
        print("User scrolled to top")
    }
    
    override func interfaceDidScrollToTop() {
        print("User went to top by tapping status bar")
    }
    
    override func interfaceOffsetDidScrollToBottom() {
        print("User scrolled to bottom")
    }
    @IBAction func onWeightChanged(_ value: Int) {
        ounces = value + 1
    }
    
    @IBAction func onTemperatureChanged(_ value: Int) {
        let temp = MeatTemperature(rawValue: value)!
        cookTemp = temp
        temperatureLabel.setText(temp.stringValue)
    }
    
    @IBAction func onTimerButton() {
        if timerRunning {
            timer.stop()
            timerButton.setTitle("Start Timer")
        } else {
            let time = cookTemp.cookTimeForOunces(ounces)
            timer.setDate(Date(timeIntervalSinceNow: time))
            timer.start()
            timerButton.setTitle("Stop Timer")
        }
        timerRunning = !timerRunning
        scroll(to: timer, at: .top, animated: true)
    }
}

