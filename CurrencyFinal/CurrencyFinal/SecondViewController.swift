//
//  SecondViewController.swift
//  CurrencyFinal
//
//  Created by Adam Cohen on 4/6/20.
//  Copyright © 2020 Adam Cohen. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController, UITextFieldDelegate {
    
    
    var audioPlayer = AVAudioPlayer()
    // Used to be for the animations of the colors
       var selectedCurve: UIView.AnimationCurve = .easeInOut
       let colors: [UIColor] = [.white, .red, .green, .orange, .blue, .lightGray, .darkGray]
       
       //changes the background color
       @IBAction func changeBackgroundColor() {
        view.changeColor(to: colors.randomElement()!, duration: 1.0,
                         options: selectedCurve.animationOption)
       }
    
    @IBAction func showAlert() {
           let alert = UIAlertController(title: "How to Use",
                                           message: "For this you must use the stock symbol which is also known as a ticker symbol. Example: Tesla=TSLA, Facebook = FB, Apple = AAPL",
                                          preferredStyle: .alert)
           let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
           alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
           }
           
    // All Values for the symbols
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockOpenLabel: UILabel!
    @IBOutlet weak var stockHighLabel: UILabel!
    @IBOutlet weak var stockLowLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockVolumeLabel: UILabel!
    @IBOutlet weak var stockLastTradingDayLabel: UILabel!
    @IBOutlet weak var stockPreviousCloseLabel: UILabel!
    @IBOutlet weak var stockChangeLabel: UILabel!
    @IBOutlet weak var stockChangePercentLabel: UILabel!
    // Text Field search
    @IBOutlet weak var stockTextField: UITextField!
    
    @IBAction func stockSearchTapped(_ sender: Any) {
    getStockQuote()
    //dismissKeyboard()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    getStockQuote()
    self.view.endEditing(true)
    return false
    }
    //this function resets all the labels from the field to clear them and then when a new search happens they will be cleared and new data will be pushed
    func resetLabels() {
    stockSymbolLabel.text = "";
    stockOpenLabel.text = "";
    stockHighLabel.text = "";
    stockLowLabel.text = "";
    stockPriceLabel.text = "";
    stockVolumeLabel.text = "";
    stockLastTradingDayLabel.text = "";
    stockPreviousCloseLabel.text = "";
    stockChangeLabel.text = "";
    stockChangePercentLabel.text = "";
    }
    
   @objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    // the keyboard will move the view up and that was the user can see waht they are typing
    view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    if self.view.frame.origin.y == 0 {
    self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
    self.view.frame.origin.y = 0
        }
    }
   override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    resetLabels()
    // the keyboard will hide and show when you tap on the view as well as the view will move up
    self.stockTextField.delegate = self
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    func getStockQuote() {
        
        let path = Bundle.main.path(forResource: "button-19", ofType:".mp3")!
               let urlMusic = URL(fileURLWithPath: path)

               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: urlMusic)
                   audioPlayer.play()
               } catch {
                   print("Couldnt load the file")
               }
            
        let session = URLSession.shared
        //https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo
        //api key for the website 0KHU4KRKVL4O1K6P
            // the api field is stored into a string and then fetched with what the field from the text was entered
            // stockTextField is taken from where the user inputed and then put into the URL and then feteched 
        let quoteURL = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(stockTextField.text ?? "")&apikey=0KHU4KRKVL4O1K6P&datatype=json")!
        let dataTask = session.dataTask(with: quoteURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
       
            print("Error:\n\(error)")
        } else {
        
            if let data = data {
            let dataString = String(data: data, encoding: String.Encoding.utf8)
                print("All the quote data:\n\(dataString!)")
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    if let quoteDictionary = jsonObj.value(forKey: "Global Quote") as? NSDictionary {
        DispatchQueue.main.async {
            //the following is the JSON data example and the below code would take each one of the lines i want to show and decode it into the app
           /* {
                "Global Quote": {
                    "01. symbol": "IBM",
                    "02. open": "115.9300",
                    "03. high": "117.3900",
                    "04. low": "115.2500",
                    "05. price": "116.9800",
                    "06. volume": "4785773",
                    "07. latest trading day": "2020-05-15",
                    "08. previous close": "116.9500",
                    "09. change": "0.0300",
                    "10. change percent": "0.0257%"
                }
            }*/
            //the follwoing gets stored as a string and saved as what it needs to be saved as after the JSON data specifications
            // forkey is basically like a split in Java that after that "" itll shoot out the data
            //each of these keys for a value and updates our UILable above
            if let symbol = quoteDictionary.value(forKey: "01. symbol") {
                self.stockSymbolLabel.text = symbol as? String
        }
            if let open = quoteDictionary.value(forKey: "02. open") {
                self.stockOpenLabel.text = open as? String
        }
            if let high = quoteDictionary.value(forKey: "03. high") {
                self.stockHighLabel.text = high as? String
        }
            if let low = quoteDictionary.value(forKey: "04. low") {
                self.stockLowLabel.text = low as? String
        }
            if let price = quoteDictionary.value(forKey: "05. price") {
                self.stockPriceLabel.text = price as? String
        }
            if let volume = quoteDictionary.value(forKey: "06. volume") {
                self.stockVolumeLabel.text = volume as? String
        }
            if let latest = quoteDictionary.value(forKey: "07. latest trading day") {
                self.stockLastTradingDayLabel.text = latest as? String
        }
            if let previous = quoteDictionary.value(forKey: "08. previous close") {
                self.stockPreviousCloseLabel.text = previous as? String
        }
            if let change = quoteDictionary.value(forKey: "09. change") {
                self.stockChangeLabel.text = change as? String
        }
            if let changePercent = quoteDictionary.value(forKey: "10. change percent") {
                self.stockChangePercentLabel.text = changePercent as? String
            }
                    }
                } else {
                    print("Error: Unable to Find Code")
        DispatchQueue.main.async {
            self.resetLabels()
                        }
                    }
                } else {
                    print("Error: JSON Error")
        DispatchQueue.main.async {
            self.resetLabels()
                    }
                }
                } else {
                print("Error: No Data Was Sent")
        DispatchQueue.main.async {
            self.resetLabels()
                }
                    }
            }
        }
        // use .resume to start the task after we create it
        dataTask.resume()
        }
    }




