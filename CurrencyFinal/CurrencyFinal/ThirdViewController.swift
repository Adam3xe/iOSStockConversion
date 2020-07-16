//
//  ThirdViewController.swift
//  CurrencyFinal
//
//  Created by Adam Cohen on 4/12/20.
//  Copyright © 2020 Adam Cohen. All rights reserved.
//

import UIKit
import AVFoundation

class ThirdViewController: UIViewController, UITextFieldDelegate {
    
    var audioPlayer = AVAudioPlayer()
    
    // Used to be for the animations of the colors
       var selectedCurve: UIView.AnimationCurve = .easeInOut
       let colors: [UIColor] = [.white, .red, .green, .orange, .yellow, .lightGray, .darkGray]
       
       //changes the background color
       @IBAction func changeBackgroundColor() {
        view.changeColor(to: colors.randomElement()!, duration: 1.0,
                         options: selectedCurve.animationOption)
       }
    // all the labels to output the data for the currency code
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyExchangeRateLabel: UILabel!
    @IBOutlet weak var currencyLastRefreshedLabel: UILabel!
    @IBOutlet weak var currencyBidValueLabel: UILabel!
    @IBOutlet weak var currencyAskValueLabel: UILabel!
    //Text Field Search
    @IBOutlet weak var currencyTextField: UITextField!
    
    
    //function when searh button is tapped to get the fucntion currency and then also dismiss the keyboard
    @IBAction func currencySearchButtonTapped(_ sender: Any) {
        // gets the currency code
        getCurrencyQuote()
        //either hitting the search or enter key will dimiss the keyboard
        dismissKeyboard()
        }
    
    

   
    //this function resets all the labels from the field to clear them and then when a new search happens they will be cleared and new data will be pushed
    func resetLabels() {
        currencyCodeLabel.text = "";
        currencyNameLabel.text = "";
        currencyExchangeRateLabel.text = "";
        currencyLastRefreshedLabel.text = "";
        currencyBidValueLabel.text = "";
        currencyAskValueLabel.text = "";
    }
    
    @objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
    }
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    // the keyboard will move the view up and that was the user can see waht they are typing
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
    //label will reset from the function above
    resetLabels()
    // the user inputs the currency code and gets inputed into the URL session api link
    self.currencyTextField.delegate = self
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    // the keyboard will hide and show when you tap on the view as well as the view will move up
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // this whole function will get the currency quote 
    func getCurrencyQuote() {
        
        let path = Bundle.main.path(forResource: "button-19", ofType:".mp3")!
        let urlMusic = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: urlMusic)
            audioPlayer.play()
        } catch {
            print("Couldnt load the file")
        }
        
        let session = URLSession.shared
        //https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=demo
        //api key for the website 0KHU4KRKVL4O1K6P
        // the api field is stored into a string and then fetched with what the field from the text was entered
        // currencyTextField is taken from where the user inputed and then put into the URL and then feteched
        let quoteURL = URL(string: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=\(currencyTextField.text ?? "")&to_currency=USD&apikey=0KHU4KRKVL4O1K6P")!
    let dataTask = session.dataTask(with: quoteURL) {
    (data: Data?, response: URLResponse?, error: Error?) in
    if let error = error {
    //if the api key is not valid this will throw the error
    print("Error:\n\(error)")
    } else {
    if let data = data {
    // this decodes the JSON data 
    let dataString = String(data: data, encoding: String.Encoding.utf8)
    print("All the quote data:\n\(dataString!)")
    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
    //This is the currency rate exchange JSON data and the below code will take each one of the needed ones and store it into the string and send it out to the labels 
    /*{
        "Realtime Currency Exchange Rate": {
            "1. From_Currency Code": "USD",
            "2. From_Currency Name": "United States Dollar",
            "3. To_Currency Code": "JPY",
            "4. To_Currency Name": "Japanese Yen",
            "5. Exchange Rate": "107.15700000",
            "6. Last Refreshed": "2020-05-17 12:43:37",
            "7. Time Zone": "UTC",
            "8. Bid Price": "-",
            "9. Ask Price": "-"
        }
    }*/
   //the follwoing gets stored as a string and saved as what it needs to be saved as after the JSON data specifications
    //forkey is basically like a split in Java that after that "" itll shoot out the data
    //each of these keys for a value and updates our UILable above
    if let quoteDictionary = jsonObj.value(forKey: "Realtime Currency Exchange Rate") as? NSDictionary {
    DispatchQueue.main.async {
        if let code = quoteDictionary.value(forKey: "1. From_Currency Code") {
            self.currencyCodeLabel.text = code as? String
        }
        if let name = quoteDictionary.value(forKey: "2. From_Currency Name") {
            self.currencyNameLabel.text = name as? String
        }
        if let rate = quoteDictionary.value(forKey: "5. Exchange Rate") {
            self.currencyExchangeRateLabel.text = "$\(rate)"
        }
        if let date = quoteDictionary.value(forKey: "6. Last Refreshed") {
            self.currencyLastRefreshedLabel.text = date as? String
    }
        if let bid = quoteDictionary.value(forKey: "8. Bid Price") {
            self.currencyBidValueLabel.text = "$\(bid)"
    }
        if let ask = quoteDictionary.value(forKey: "9. Ask Price") {
            self.currencyAskValueLabel.text = "$\(ask)"
    }
}
    // unable to find the right currency code
    } else {
       print("Error: unable to find quote")
            DispatchQueue.main.async {
                self.resetLabels()
        }
    }
        // unable to to get the json data .. api not responding
    } else {
        print("Error: unable to convert json data")
            DispatchQueue.main.async {
        self.resetLabels()
        }
            }
    } else {
        
    // the following data wasnt decoded properly
        print("Error: did not receive data")
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

