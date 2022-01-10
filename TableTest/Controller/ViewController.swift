//
//  ViewController.swift
//  TableTest
//
//  Created by Michael Angelo Zafra on 1/10/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var audioPlayer = AVAudioPlayer()
    
    var cellReuseIdentifier = "cell"
    var test: String? = "cell"
    
    var progressValue = 0.0
    var animals: [Animal?] = []
    
    let animal: [String:String] = ["key_horse":"Horse", "key_Cow":"Cow", "key_Camel":"Camel", "key_Sheep":"Sheep", "key_Goat":"Goat"]
    
    let dog: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.5)
        loadJsonFile()
        loadSoundFile()
    }
    
    @objc func updateProgress() {
        progressValue = progressValue + 0.1
        progressView.progress = Float(progressValue)
        if progressValue <= 1.0 {
            print("progress if")
            self.perform(#selector(updateProgress), with: nil, afterDelay: 0.5)
            //            animals.append("Horse \(progressValue) aabcd")
            //            tableview.reloadData()
        } else {
            print("progress else")
            animals.append(Animal(name: "Horse"))
            animals.append(Animal(name: "Cow"))
            animals.append(Animal(name: "Camel"))
            animals.append(Animal(name: "Sheep"))
            animals.append(Animal(name: "Goat",description: "Kambing"))
            //            animals.append(dog)
            tableview.reloadData()
            progressView.isHidden = true
            
            audioPlayer.stop()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("animals count \(animals.count)")
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableview.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell? ?? UITableViewCell()
        
        //        // set the text from the data model
        if let display = self.animals[indexPath.row] {
            cell.textLabel?.text = "\(display.name) 🔴 - \(display.description ?? "")"
        } else {
            cell.textLabel?.text = "Default"
        }
        
        //        do {
        //            let display = try self.animals[indexPath.row]
        //            cell.textLabel?.text = display
        //        } catch {
        //           cell.textLabel?.text = "Default"
        //        }
        
        print("display cell 🔴🔴🔴🔴🔴🔴🔴🔴")
        return cell
    }
    
    func loadJsonFile() {
        if let path = Bundle.main.path(forResource: "animals", ofType: "json") {
            print("path \(path)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print("data \(data)")
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print("jsonResult \(jsonResult)")
                
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    // do stuff
                    if let array = jsonResult["animals"] as? NSArray { //[Animal?]
                        let animal = array[0] as! Dictionary<String, AnyObject>
                        print("json animal \(animal)")
                    }
                } else {
                    print("error dictionary")
                }
            } catch {
                // handle error
                print("error")
            }
        } else {
            print("file not found")
        }
    }
    
    func loadSoundFile() {
        if let sound = Bundle.main.path(forResource: "sound", ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer (contentsOf: URL(fileURLWithPath: sound))
                audioPlayer.play()
            } catch {
                print("error")
            }
        } else {
            print("file not found")
        }
    }
}
