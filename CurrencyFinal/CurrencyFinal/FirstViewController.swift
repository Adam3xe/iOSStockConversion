//
//  FirstViewController.swift
//  CurrencyFinal
//
//  Created by Adam Cohen on 4/6/20.
//  Copyright © 2020 Adam Cohen. All rights reserved.
//

import UIKit
import AVFoundation



class FirstViewController: UIViewController {
    
    
    
    //sound for the button
    var audioPlayer = AVAudioPlayer()
    
    // Used to be for the animations of the colors
    var selectedCurve: UIView.AnimationCurve = .easeInOut
    let colors: [UIColor] = [.white, .red, .green, .orange, .yellow, .lightGray, .darkGray]
    
    //changes the background color
    @IBAction func changeBackgroundColor() {
     view.changeColor(to: colors.randomElement()!, duration: 1.0,
                      options: selectedCurve.animationOption)
    }
    
     @IBAction func showAlert() {
        let alert = UIAlertController(title: "How to Use",
                                        message: "All currencies that are inputed have to be used with the country currency code, for example the codes in the first page are some popular ones and can give you can idea of what to use",
                                       preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
         present(alert, animated: true, completion: nil)
         
        }
        
    
    
    //@IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var audLabel: UILabel!
    @IBOutlet weak var inrLabel: UILabel!
    @IBOutlet weak var mxnLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var plnLabel: UILabel!
    @IBOutlet weak var hkdLabel: UILabel!
    @IBOutlet weak var kpwLabel: UILabel!
    @IBOutlet weak var aedLabel: UILabel!
    
    //adding bitcoin since its in the api
    @IBOutlet weak var btcLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func getRatesClicked(_ sender: Any) {
            
        let path = Bundle.main.path(forResource: "button-19", ofType:".mp3")!
        let urlMusic = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: urlMusic)
            audioPlayer.play()
        } catch {
           print("Could not load file")
        }
        
        
            // since the url is not secured you have to add a line into the info.plist,
            // add App Transport Security Settings, then add Allow Arbitrary Loads and change the NO to YES
            // this way it is able to get the call from the API from a non secure connection
            let url = URL(string: "http://data.fixer.io/api/latest?access_key=eb0aac5bc27627de6a8f365461986efe")
            
            // urlsession gets the data and manages transferring tasks with data in a specified network
            // adding the .shared makes sure that it keeps the same session instance (singleton) even with multiple requests
            let session = URLSession.shared
            
            let task = session.dataTask(with: url!) { (data, response, error) in
                // if there is an error, return an alert with a message that is taken from the localized description of the error
                if error != nil {
                    print("error in the code")
                } else {
                    // if you do have data then go ahead and present the data
                    if data != nil {
                        
                        do {
                        // convert the JSON format into strings, booleans, integers
                        // mutableContainers allows us to work with arrays and dictionaries
                        let jsonResponse  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                            
                           
                            DispatchQueue.main.async {
                                
                                //the following is put as a popular rates as a main page quick view
                                if let rates = jsonResponse["rates"] as? [String : Any] {
                                    
                                    if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text  = "USD: \(usd)"
                                    }
                                    if let eur = rates["EUR"] as? Double {
                                    self.eurLabel.text = "EUR: \(eur)"
                                    }
                                    if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                    }
                                    if let cad = rates["CAD"] as? Double {
                                    self.cadLabel.text = "CAD: \(cad)"
                                    }
                                    if let aud = rates["AUD"] as? Double {
                                    self.audLabel.text = "AUD: \(aud)"
                                    }
                                    if let inr = rates["INR"] as? Double {
                                    self.inrLabel.text = "INR: \(inr)"
                                    }
                                    if let mxn = rates["MXN"] as? Double {
                                    self.mxnLabel.text = "MXN: \(mxn)"
                                    }
                                    if let rub = rates["RUB"] as? Double {
                                    self.rubLabel.text = "RUB: \(rub)"
                                    }
                                    if let pln = rates["PLN"] as? Double {
                                    self.plnLabel.text = "PLN: \(pln)"
                                    }
                                    if let hkd = rates["HKD"] as? Double {
                                    self.hkdLabel.text = "HKD: \(hkd)"
                                    }
                                    if let kpw = rates["KPW"] as? Double {
                                    self.kpwLabel.text = "KPW: \(kpw)"
                                    }
                                    if let aed = rates["AED"] as? Double {
                                    self.aedLabel.text = "AED: \(aed)"
                                    }
                                    if let btc = rates["BTC"] as? Double {
                                    self.btcLabel.text = "BTC: \(btc)"
                                    }
                                    
                                }
                            }
                            
                          // if none work itll throw and error
                        } catch {
                            print("error")
                        }
                        
                    }
                }
            }
            
            // use .resume to start the task after we create it
            task.resume()
            
        }
        
    }



