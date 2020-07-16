//
//  UIView.swift
//  CurrencyFinal
//
//  Created by Adam Cohen on 4/30/20.
//  Copyright © 2020 Adam Cohen. All rights reserved.
//

import UIKit

extension UIView {
    // this would change the color background at intervals
    func changeColor(to color: UIColor, duration: TimeInterval, options: UIView.AnimationOptions) {
      UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
        self.backgroundColor = color
      }, completion: nil)
    }
}
