//
//  RegisterViewController.swift
//  wikipedia
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//

import UIKit
import CoreData
import TextFieldEffects

class RegisterViewController: BaseViewController,UINavigationControllerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var fistNameTextfield : HoshiTextField!
    @IBOutlet weak var lastNameTextfield : HoshiTextField!
    @IBOutlet weak var emailIDTextfield : HoshiTextField!
    @IBOutlet weak var mobileNumberTextfield : HoshiTextField!
    @IBOutlet weak var passwordTextfield : HoshiTextField!
    @IBOutlet weak var profileImageView : UIImageView!

    @IBOutlet weak var eyeButtonClick: UIButton!

    var passwordIconClick : Bool = false
    var  addImageBool : Bool? = false
    var imageData : Data?

    override func viewDidLoad() {
        context = appDelegate.persistentContainer.viewContext
        
        fistNameTextfield.delegate = self
        lastNameTextfield.delegate = self
        emailIDTextfield.delegate = self
        mobileNumberTextfield.delegate = self
        passwordTextfield.delegate = self

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        
        if (fistNameTextfield.text?.isBlank)! {
            self.showAlertMessage(title: "", message: "Please enter First Name")
        } else if (lastNameTextfield.text?.isBlank)! {
            self.showAlertMessage(title: "", message: "Please enter Last Name")
        } else if emailIDTextfield.text?.isEmail == false {
            self.showAlertMessage(title: "", message: "Please enter valid Email ID ")
        } else if mobileNumberTextfield.text?.isAlphanumeric == false {
            self.showAlertMessage(title: "", message: "Please enter valid Mobile Number")
        } else if (passwordTextfield.text?.isBlank)! {
            self.showAlertMessage(title: "", message: "Please enter password")
        } else if addImageBool == false {
            self.showAlertMessage(title: "", message: "Please add Profile Image")
        } else {
            self.startActivity()

            self.delay(3.0, closure: {
                self.saveToEntity()
                self.stopActivity()
                self.keychain.set(self.emailIDTextfield.text!, forKey: "emailId")
                self.keychain.set(self.passwordTextfield.text!, forKey: "password")
                self.keychain.set(self.fistNameTextfield.text! + self.lastNameTextfield.text!, forKey: "name")
                self.keychain.set(self.mobileNumberTextfield.text!, forKey: "contactNumber")
                
                let refreshAlert = UIAlertController(title: "Wikipedia", message: "Welcome to wikipedia", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
                    
                    self.navigationController?.pushViewController(newViewController, animated: true)

                }))
                self.present(refreshAlert, animated: true, completion: nil)
            })
        }
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
    
    @IBAction func addProfileImageButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Libray", style: .default , handler:{ (UIAlertAction)in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    
        
    }
    
    
    func saveToEntity() {
        if(checkAddIfExisting()) {
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Account", into: context)
            let userName = fistNameTextfield.text! + " " + lastNameTextfield.text!
            
            newUser.setValue(userName, forKey: "name")
            newUser.setValue(emailIDTextfield.text, forKey: "emailId")
            newUser.setValue(Int64(mobileNumberTextfield.text!), forKey: "contactNumber")
            newUser.setValue(passwordTextfield.text, forKey: "password")
            newUser.setValue(imageData , forKey: "image")

            do {
                try context.save()
                print("Saved")
            } catch {
                print("There was an error")
            }
        }
    }
    
    func createContactItem(with image: UIImage) {
        imageData = NSData (data: UIImageJPEGRepresentation(image, 0.3)!) as Data
        keychain.set(imageData!, forKey: "image")

        if let noteImage = UIImage(data: NSData (data: UIImageJPEGRepresentation(image, 0.3)!) as Data) {
            self.profileImageView.image = noteImage
            self.profileImageView.makeViewCircular()
            addImageBool = true
        }
    }

    func checkAddIfExisting() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        var flag: Bool! = false
        
        request.predicate = NSPredicate(format: "emailId = %@", emailIDTextfield.text!);
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count > 0 {
                self.showAlertMessage(title: "Error", message: "emailId       "+emailIDTextfield.text!+"        already existing.")
                flag = false
            } else {
                flag = true
            }
        } catch {
            print("error")
        }
        
        return flag
    }
}


extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            picker.dismiss(animated: true, completion: nil)
            self.createContactItem(with: image)
        }
    }

}


