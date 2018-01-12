//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Apple on 12/01/18.
//  Copyright (c) 2018 Apple. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ConverterDisplayLogic: class
{
  func displayExchangeRate(viewModel: Converter.ExchangeRate.ViewModel)
}

class ConverterViewController: UIViewController, ConverterDisplayLogic
{
  var interactor: ConverterBusinessLogic?
    
    var secondaryCurrencyBaseValue: Float = 1.1 {
        didSet {
            secondaryCurrencyValueLabel.text = "\(secondaryCurrencyBaseValue)"
            refreshSecondaryCurrencyResultant()
        }
    }

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ConverterInteractor()
    let presenter = ConverterPresenter()
    viewController.interactor = interactor
    interactor.presenter = presenter
    presenter.viewController = viewController
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doExchangeRate()
  }
    
  //@IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var primaryCurrencyShortNameLabel: UILabel!
    @IBOutlet weak var secondaryCurrencyValueLabel: UILabel!
    @IBOutlet weak var secondaryCurrencyShortNameLabel: UILabel!
    
    @IBOutlet weak var primaryCurrencyValueToConvertLabel: UILabel!
    @IBOutlet weak var secondaryCurrencyResultantValueLabel: UILabel!
    
    @IBOutlet weak var primaryCurrencyNameLabel: UILabel!
    @IBOutlet weak var secondaryCurrencyNameLabel: UILabel!
    
    @IBOutlet weak var currencyRatesComparisionYearLabel: UILabel!
    
    @IBOutlet weak var datePickerContainerVisualBlurView: UIView!
    
    @IBAction func inputButtonTapped(button: UIButton) {
        doActionFor(inputValue: button.tag)
    }
    
    @IBAction func primaryCurrencyChangeTapped(button: UIButton) {
        
    }
    
    @IBAction func secondaryCurrencyChangeTapped(button: UIButton) {
        
    }
  
    func doExchangeRate(urlPath: String = "/latest")
  {
    let request = Converter.ExchangeRate.Request(urlPath: urlPath)
    interactor?.doExchangeRate(request: request)
  }
  
  func displayExchangeRate(viewModel: Converter.ExchangeRate.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    //MARK: - Private methods
    
    private func doActionFor(inputValue: Int) {
        switch inputValue {
        case 0...9:
            if primaryCurrencyValueToConvertLabel.text == "0" {
                primaryCurrencyValueToConvertLabel.text = ""
            }
            primaryCurrencyValueToConvertLabel.text = "\(primaryCurrencyValueToConvertLabel.text ?? "")\(inputValue)"
            refreshSecondaryCurrencyResultant()
        case 10: //Decimal
            if !((primaryCurrencyValueToConvertLabel.text ?? "").contains(Character("."))) {
                primaryCurrencyValueToConvertLabel.text = "\(primaryCurrencyValueToConvertLabel.text ?? "")."
                refreshSecondaryCurrencyResultant()
            }
        case 11: //Delete
            primaryCurrencyValueToConvertLabel.text = "0"
            refreshSecondaryCurrencyResultant()
        case 12: //Back
            if primaryCurrencyValueToConvertLabel.text!.count > 1 {
                let index: String.Index = (primaryCurrencyValueToConvertLabel.text?.index(String.Index(encodedOffset: 0), offsetBy: primaryCurrencyValueToConvertLabel.text!.count - 1))!
                let resultantString = primaryCurrencyValueToConvertLabel.text![..<index]
                primaryCurrencyValueToConvertLabel.text = String(resultantString)
            } else if primaryCurrencyValueToConvertLabel.text!.count == 1 {
                primaryCurrencyValueToConvertLabel.text = "0"
            }
            refreshSecondaryCurrencyResultant()
        case 13: //Switch
            makeChangesForSwitch()
        default:
            break
        }
    }
    
    private func refreshSecondaryCurrencyResultant() {
        secondaryCurrencyResultantValueLabel?.text = String(Float(primaryCurrencyValueToConvertLabel.text ?? "")! * secondaryCurrencyBaseValue)
    }
    
    private func makeChangesForSwitch() {
        
    }
    
    private func showDatePickerView() {
        datePickerContainerVisualBlurView.isHidden = false
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.datePickerContainerVisualBlurView.alpha = 1
        })
    }
    
    private func hideDatePickerView() {
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.datePickerContainerVisualBlurView.alpha = 0
        }) { (completed) in
            self.datePickerContainerVisualBlurView.isHidden = true
        }
    }

}
