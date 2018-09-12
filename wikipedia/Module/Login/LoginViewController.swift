//
//  LoginViewController.swift
//  wikipedia
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//

import UIKit
import CoreData
import TextFieldEffects
import KeychainSwift

class LoginViewController: BaseViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!

    @IBOutlet weak var emailIDTextfield: HoshiTextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var eyeButtonClick: UIButton!
    
    var passwordIconClick : Bool = false

    override func viewDidLoad() {
        context = appDelegate.persistentContainer.viewContext

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        navigationController?.pushViewController(newViewController, animated: true)
    }

    @IBAction func passwordVisibleIconClicked(_ sender: Any) {
        
        if(passwordIconClick == false) {
            passwordTextfield.isSecureTextEntry = false
            eyeButtonClick.setBackgroundImage(UIImage(named:"password_visible"), for: .normal)
            
            passwordIconClick = true
        } else {
            eyeButtonClick.setBackgroundImage(UIImage(named:"password_unvisible"), for: .normal)
            
            passwordTextfield.isSecureTextEntry = true
            passwordIconClick = false
        }
        
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        if (emailIDTextfield.text?.isBlank)! {
            self.showAlertMessage(title: "", message: "Please enter EmailId")
        } else if (passwordTextfield.text?.isBlank)! {
            self.showAlertMessage(title: "", message: "Please enter password")
        }else {
            self.startActivity()
        
        self.delay(3.0, closure: {
            let num = self.emailIDTextfield.text!
                if(self.emailIDTextfield.text! != "" && self.passwordTextfield.text! != "") {
                    if(num.isEmpty == false) {
                        self.searchFromEntity()
                    } else {
                        self.showDialog(title: "Error", message: "Invalid credentials!")
                    }
                } else {
                    self.showDialog(title: "Error", message: "Blank field not allowed!")
                }
            })
        }
    }
    
    func searchFromEntity() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        
        request.predicate = NSPredicate(format: "emailId = %@", emailIDTextfield.text!); request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    let emailID = result.value(forKey: "emailId") as? String
                    let passwordValue = result.value(forKey: "password") as? String
                    let name = result.value(forKey: "name") as? String
                    let image = result.value(forKey: "image") as? Data
                    let contactNumber = result.value(forKey: "contactNumber") as? Int64
                    let myString = String(describing: contactNumber)

                    if(emailID == emailIDTextfield.text && passwordValue == passwordTextfield.text) {
                        self.stopActivity()

                        keychain.set(emailID!, forKey: "emailId")
                        keychain.set(passwordValue!, forKey: "password")
                        keychain.set(name!, forKey: "name")
                        keychain.set(image!, forKey: "image")
                        keychain.set(myString, forKey: "contactNumber")
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
                        navigationController?.pushViewController(newViewController, animated: true)
                    } else {
                        self.stopActivity()

                        showDialog(title: "Error", message: "Invalid Credentials")
                    }
                }

            } else {
                self.stopActivity()

                print("No results")
                showDialog(title: "Invalid Request", message: "No user found with  #"+emailIDTextfield.text!)
            }
        } catch {

            print("Couldn't fetch results")
        }
    }
    
    func checkLoggedName() -> String {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        var name: String! = ""
        
        request.predicate = NSPredicate(format: "emailId = %@", emailIDTextfield.text!);
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            for result in results as! [NSManagedObject] {
                let tempFN = result.value(forKey: "name") as! String
                name = tempFN
            }
        } catch {
            print("error")
        }
        
        return name;
    }
    
    func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

    

}
