//
//  PaymentVC.swift
//  VetsNow
//
//  Created by Olamide Olatunji on 10/10/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit
import PassKit


class PaymentVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var cartInformation: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartInformation.text = "\(cart)"
        totalPrice.text = "\(userTotalCount)"
        
        tableView.delegate = self
        tableView.dataSource = self
        
       // self.configureView()
        applePayPurchase.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)

    }
    @IBOutlet weak var applePayPurchase: UIButton!
    
    func paymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "merchant.com.Grooma";
        paymentRequest.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa, PKPaymentNetwork.masterCard];
        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS;
        paymentRequest.countryCode = "US"; // e.g. US
        paymentRequest.currencyCode = "USD"; // e.g. USD
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Total Items", amount: NSDecimalNumber(string: "\(50)"))
        ]
        return paymentRequest
    }
    
    @IBAction func applePayButtonClicked(_ sender: AnyObject) {
        
        
        let paymentRequest = self.paymentRequest()
        // Example: Promote PKPaymentAuthorizationViewController to optional so that we can verify
        // that our paymentRequest is valid. Otherwise, an invalid paymentRequest would crash our app.
        if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            as PKPaymentAuthorizationViewController?
        {
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        } else {
            print("Error: Payment request is invalid.")
        }
        
    }
    
   /*     let request = PKPaymentRequest()
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.present(applePayController, animated: true, completion: nil)
        
         applePayController.delegate = self
        
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Your Selected Items", amount: 0)  ] */
        

    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "GroomaAppmerchant.com.Grooma" // Fill in your merchant ID here!
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentcell", for: indexPath)
        
        return cell
    }
    
}

extension PaymentVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController!) {
        controller.dismiss(animated: true, completion: nil)
    }
}
