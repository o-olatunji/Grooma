//
//  StripePaymentVC.swift
//  VetsNow
//
//  Created by Olamide Olatunji on 10/10/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit
import Stripe

class StripePaymentVC: UIViewController, STPPaymentCardTextFieldDelegate {
    
    @IBAction func cancelPaymentButtonClicked(_ sender: AnyObject) {
        
        let viewDrop = self.popoverPresentationController
        
        viewDrop?.dismissalTransitionWillBegin()
        
    }
    var paymentTextField: STPPaymentCardTextField! = nil
    
    
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        paymentTextField = STPPaymentCardTextField(frame: CGRect(x: 20, y: 150, width:self.view.frame.size.width - 40, height: 40))
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        //  submitButton = UIButton(type: UIButtonType.system)
        //   submitButton.frame = CGRect(x: 15, y: 100, width: 100, height: 44)
        // submitButton.isEnabled = false
        // submitButton.setTitle("Submit", for: UIControlState.normal)
        //   submitButton.addTarget(self, action: #selector(self.submitCard(_ :)), for: UIControlEvents.touchUpInside)
        //  view.addSubview(submitButton)
    }
    
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        submitButton.isEnabled = textField.valid
        
    }
    
    @IBAction func submitCard(_ sender: AnyObject) {
        
        // If you have your own form for getting credit card information, you can construct
        // your own STPCardParams from number, month, year, and CVV.
        let card = paymentTextField.cardParams
        
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            guard token != nil else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            // TODO: send the token to your server so it can create a charge
            let alert = UIAlertController(title: "Card Saved", message: "Your Card Information Has Been Saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}
