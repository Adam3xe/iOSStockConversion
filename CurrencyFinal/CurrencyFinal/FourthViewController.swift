//
//  FourthViewController.swift
//  CurrencyFinal
//
//  Created by Adam Cohen on 4/20/20.
//  Copyright © 2020 Adam Cohen. All rights reserved.
//


import UIKit
import AVFoundation

class FourthViewController: UIViewController, UITextFieldDelegate {
    
    var audioPlayer = AVAudioPlayer()

    // Used to be for the animations of the colors
       var selectedCurve: UIView.AnimationCurve = .easeInOut
       let colors: [UIColor] = [.white, .red, .green, .orange, .yellow, .lightGray, .darkGray]
       
       //changes the background color
       @IBAction func changeBackgroundColor() {
        view.changeColor(to: colors.randomElement()!, duration: 1.0,
                         options: selectedCurve.animationOption)
       }
    // different labels for the currency names
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var fromCurrencyNameLabel: UILabel!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var toCurrencyNameLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var lastRefreshedLabel: UILabel!
    
    //Text Field Search
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    
    // this is for the function to happen when the button is tapped itll get the conversion and also dismiss the keyboard if it is popped up
    @IBAction func conversionSearchButtonTapped(_ sender: Any) {
    getConversionQuote()
    dismissKeyboard()
    }
    
    // this is the text field should return function for all the returns for the JSON
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    getConversionQuote()
    self.view.endEditing(true)
    return false
    }
    
    // resetLabels gives a new reset on all the given fields so they are refresed at nil 
    func resetLabels(){
        fromCurrencyLabel.text = "";
        fromCurrencyNameLabel.text = "";
        toCurrencyLabel.text = "";
        toCurrencyNameLabel.text = "";
        exchangeRateLabel.text = "";
        lastRefreshedLabel.text = "";
    }
   @objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
    }
    
    // this function will show the keyboard up and move the application view up
    @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    if self.view.frame.origin.y == 0 {
    self.view.frame.origin.y -= keyboardSize.height
        }
            }
                }
    
    // this function will hide the keybaord after you click away
    @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
    self.view.frame.origin.y = 0
    }
        }
    //this will have all the functions happening at once this is the main part
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    resetLabels()
        self.toCurrencyTextField.delegate = self
        self.fromCurrencyTextField.delegate = self
        
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getConversionQuote(){
        
        // the first part will be the button clicking and then a sound and then the rest of the session will happen 
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
        // \(toCurrencyTextField.text ??"")
        // this api wouldnt let me at first put two input fields of text but then it was a syntax error
        // another idea i had was to split the URL into two strings and then combine them but it was not 100% reliable
        
        let quoteURL = URL(string: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=\(fromCurrencyTextField.text ?? "")&to_currency=\(toCurrencyTextField.text ?? "")&apikey=0KHU4KRKVL4O1K6P")!
        //let string1 = "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=\(fromCurrencyTextField.text ?? "")"
        //let string2 = "&to_currency=\(toCurrencyTextField.text ?? "")&apikey=0KHU4KRKVL4O1K6P"
        //let quoteURL = string1 + string2
        let dataTask = session.dataTask(with: quoteURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
        print("Error:\n\(error)")
        } else {
        if let data = data {
        let dataString = String(data: data, encoding: String.Encoding.utf8)
        print("All the quote data:\n\(dataString!)")
        if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
        if let quoteDictionary = jsonObj.value(forKey: "Realtime Currency Exchange Rate") as? NSDictionary {
        DispatchQueue.main.async {
            //This is the currency rate exchange JSON data and the below code will take each one of the needed ones and store it into the string and send it out to the labels
               /*{
                   "Realtime Currency Exchange Rate": {
                       "1. From_Currency Code": "USD", <-- this gets changed by the user now
                       "2. From_Currency Name": "United States Dollar", <-- depends what the user wants it this will also change according 
                       "3. To_Currency Code": "JPY", <-- this gets changed by the user
                       "4. To_Currency Name": "Japanese Yen", <-- depending on what the user changes to pervious this also will change
                       "5. Exchange Rate": "107.15700000",
                       "6. Last Refreshed": "2020-05-17 12:43:37",
                       "7. Time Zone": "UTC",
                       "8. Bid Price": "-",
                       "9. Ask Price": "-"
                   }
               }*/
            //The following takes the data from the output on the JSON and decodes it after the given keys
            //The search pattern that valueForKey: uses to find the correct value to return is described
            if let code = quoteDictionary.value(forKey: "1. From_Currency Code") {
                self.fromCurrencyLabel.text = code as? String
            }
            if let name = quoteDictionary.value(forKey: "2. From_Currency Name") {
                self.fromCurrencyNameLabel.text = name as? String
        }
            if let code = quoteDictionary.value(forKey: "3. To_Currency Code") {
                self.toCurrencyLabel.text = code as? String
        }
            if let name = quoteDictionary.value(forKey: "4. To_Currency Name") {
                self.toCurrencyNameLabel.text = name as? String
        }
            if let rate = quoteDictionary.value(forKey: "5. Exchange Rate") {
                self.exchangeRateLabel.text = "$\(rate)"
        }
            if let date = quoteDictionary.value(forKey: "6. Last Refreshed") {
                self.lastRefreshedLabel.text = date as? String
        }
                }
            } else {
            //this would sent out an error that we couldnt find quote
                print("Error: unable to find quote")
            DispatchQueue.main.async {
                self.resetLabels()
        }
        }
        } else {
            // sends out an error that the json data couldnt be converted
            print("Error: unable to convert json data")
            DispatchQueue.main.async {
                self.resetLabels()
        }
        }
            } else {
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

