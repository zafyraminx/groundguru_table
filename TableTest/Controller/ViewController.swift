//
//  ViewController.swift
//  TableTest
//
//  Created by Michael Angelo Zafra on 1/10/22.
//

import UIKit
import AVFoundation
import JGProgressHUD

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
    
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.5)
        loadSoundFile()
        print("Didload")
        
        
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        progressView.isHidden = true
//        hud.dismiss(afterDelay: 3.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("didAppear")
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
//            animals.append(Animal(name: "Horse"))
//            animals.append(Animal(name: "Cow"))
//            animals.append(Animal(name: "Camel"))
//            animals.append(Animal(name: "Sheep"))
//            animals.append(Animal(name: "Goat",description: "Kambing"))
//            //            animals.append(dog)
//            tableview.reloadData()
            loadJsonFile()
            
            hud.dismiss(animated: false)
            audioPlayer.stop()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("animals count \(animals.count)")
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableview.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell? ?? UITableViewCell()
        
        if let display = self.animals[indexPath.row] {
            //Cell Text
            cell.textLabel?.text = "\(display.name) 🔴 - \(display.description ?? "")"
            //Cell Image
            cell.imageView?.image = UIImage(named: display.name.lowercased())
        } else {
            cell.textLabel?.text = "Default"
        }
        print("display cell 🔴🔴🔴🔴🔴🔴🔴🔴")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Click \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let display = self.animals[indexPath.row] {
            let alert = UIAlertController(title: display.name, message: display.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                self.performSegue(withIdentifier: "list_details", sender: display)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadJsonFile() {
        if let path = Bundle.main.path(forResource: "animals", ofType: "json") {
            print("path \(path)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print("data \(data)")
                let decoder = JSONDecoder()
                if let animalData = try? decoder.decode(Animals.self, from: data) {
                    print("animalData \(animalData)")
                    self.animals = animalData.animals
                    tableview.reloadData()
                }
                
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                print("jsonResult \(jsonResult)")
//                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
//                    // do stuff
//                    if let array = jsonResult["animals"] as? NSArray { //[Animal?]
//                        let animal = array[0] as! Dictionary<String, AnyObject>
//                        print("json animal \(animal)")
//                    }
//                } else {
//                    print("error dictionary")
//                }
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

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //ViewController with Navigation Controller
        if let navigationController = segue.destination as? UINavigationController {
            let childViewController = navigationController.topViewController as? DetailsViewController
            childViewController?.segueData = sender as? Animal
        }
        
        //Direct ViewController
//        let destinationVC = segue.destination as! DetailsViewController
//        destinationVC.segueData = animals[0]
    }
}
