//
//  AnimationPicker.swift
//  CurrencyFinal
//
//  Created by Adam Cohen on 4/30/20.
//  Copyright © 2020 Adam Cohen. All rights reserved.
//


//Tutorial followed on https://www.raywenderlich.com/5976-uiview-animations-tutorial-practical-recipes how to add color to the background of each tab
// I learned how to add the color and there are animation curves 

import UIKit

protocol AnimationCurvePickerViewControllerDelegate: class {

  func animationCurvePickerViewController(_ controller: AnimationCurvePickerViewController, didSelectCurve curve: UIView.AnimationCurve)

}

class AnimationCurvePickerViewController: UITableViewController {

  static let cellID = "curveCellID"

  let curves: [UIView.AnimationCurve] = [
    .easeIn,
    .easeOut,
    .easeInOut,
    .linear
  ]

  weak var delegate: AnimationCurvePickerViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: AnimationCurvePickerViewController.cellID)
  }

}

extension UIView.AnimationCurve {

  //Produces a user-displayable title for the curve
  var title: String {
    switch self {
    case .easeIn: return "Ease In"
    case .easeOut: return "Ease Out"
    case .easeInOut: return "Ease In Out"
    case .linear: return "Linear"
    }
  }

  //Converts this curve into it's corresponding UIView.AnimationOptions value for use in animations
  var animationOption: UIView.AnimationOptions {
    switch self {
    case .easeIn: return .curveEaseIn
    case .easeOut: return .curveEaseOut
    case .easeInOut: return .curveEaseInOut
    case .linear: return .curveLinear
    }
  }

}
