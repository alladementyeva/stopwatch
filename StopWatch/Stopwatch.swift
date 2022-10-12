//
//  ViewController.swift
//  StopWatch
//
//  Created by user on 10.10.2022.
//

import UIKit

class Stopwatch: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stopWatchLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lapResetButton: UIButton!
    
    var stopWatch: Timer!
    var counter: Double = 0.0
    var arrayLap: [String] = []
    var playTimerOn = true
    var lapTimerOn = true
    
    // Called when screen is created
    override func viewDidLoad() {
        table.delegate = self
        table.dataSource = self
    }
    
    
    @IBAction func startAndPauseAction(_ sender: UIButton) {
        if playTimerOn {
            // switch to PAUSE
            stopWatch = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(tikStopWatch), userInfo: nil, repeats: true)
            
            changeStartStopButton(button: sender, image: "pause.fill", text: "Pause")
            
            // enable LAP
            lapResetButton.isEnabled = true
            lapTimerOn = true
            changeLapResetButton(by: lapResetButton, "plus.rectangle.fill", text: "Lap")
        }
        else {
            // enable PLAY
            stopWatch.invalidate()
            changeStartStopButton(button: sender, image: "play.fill", text: "Play")
            
            // enable RESET
            lapTimerOn = false
            changeLapResetButton(by: lapResetButton, "clear.fill", text: "Reset")
        }
    }
    
    @objc func tikStopWatch() {
        counter += 0.035
        let nMinutes = (Int)(counter / 60)
        var sMinutes: String = "\(nMinutes)"
        if nMinutes < 10 {
            sMinutes = "0" + sMinutes
        }
        
        let nSeconds = counter.truncatingRemainder(dividingBy: 60)
        var sSeconds: String = String(format: "%.2f", nSeconds)
        if nSeconds < 10 {
            sSeconds = "0" + sSeconds
        }
        
        stopWatchLabel.text = sMinutes + ":" + sSeconds
    }
    
    // Event for button lap and reset
    @IBAction func lapAndResetTimer(_ sender: UIButton) {
        if lapTimerOn {
            changeLapResetButton(by: sender, "plus.rectangle.fill", text: "Lap")
            arrayLap.append(stopWatchLabel.text!)
            table.reloadData()
        } else {
            guard playTimerOn else { return }
            arrayLap.removeAll()
            table.reloadData()
            changeLapResetButton(by: sender, "plus.rectangle.fill", text: "Lap")
            sender.isEnabled = false
            stopWatchLabel.text = "00:00"
            counter = 0.0
        }

    }
    func changeStartStopButton(button: UIButton, image: String, text: String) {
        playTimerOn = !playTimerOn
        // button.titleLabel?.text = text
        button.setTitle(text, for: UIControl.State())
        button.setImage(UIImage(systemName:image), for: UIControl.State())
    }
    
    func changeLapResetButton(by button: UIButton, _ image: String, text title: String) {
        button.setTitle(title, for: UIControl.State())
        button.setImage(UIImage(systemName: image), for: UIControl.State())
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath )->UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath) as! TableRow
        
        cell.lapLabel.textColor = .white
        cell.lapLabel?.text = arrayLap[indexPath.row]
        //        cell.textLabel?.textColor = .white
        //        cell.textLabel?.text = arrayLap[indexPath.row]
        
        return cell
    }
}

