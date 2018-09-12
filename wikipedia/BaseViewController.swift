//
//  HomeViewController.swift
//  wikipedia
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//


import UIKit
import NVActivityIndicatorView
import SDWebImage
import KeychainSwift

class BaseViewController: UIViewController,NVActivityIndicatorViewable {
    
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        NVActivityIndicatorView.DEFAULT_TYPE = NVActivityIndicatorType.ballClipRotatePulse

    }

    func delay(_ delay:Double, closure : @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func startActivity()  {
        self.startAnimating()
    }
    
    func stopActivity()  {
        self.stopAnimating()
    }
    
    @IBAction func act_backNvaigation(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func act_Home(_ sender: UIButton) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuTapped"), object: nil)
    }
        
    public func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
}





