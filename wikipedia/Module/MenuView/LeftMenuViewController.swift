//
//  HomeViewController.swift
//  wikipedia
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//


import UIKit
import SDWebImage
import KeychainSwift

let menuItems = ["Home","LogOut"]
let menuimageItems = ["home","logout"]

class LeftMenuViewController: BaseViewController {

    @IBOutlet weak var m_MenuListOutSideView: UIView!
    @IBOutlet weak var m_menuTableView: UITableView!
    
    @IBOutlet weak var m_TableviewLeadingcons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singletapGuester:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LeftMenuViewController.touchHandle))
        singletapGuester.numberOfTapsRequired = 1
        m_MenuListOutSideView.addGestureRecognizer(singletapGuester)
        m_MenuListOutSideView.isUserInteractionEnabled = true
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(LeftMenuViewController.wasDragged(_:)))
        self.view!.addGestureRecognizer(gesture)
        self.view!.isUserInteractionEnabled = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LeftMenuViewController.reloadMenu),
            name: NSNotification.Name(rawValue: "ReloadMenu"),
            object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @objc func wasDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            let t = (self.view.frame.width / 2 ) - self.m_menuTableView.frame.size.width
            
            if(translation.x <= 0){
                if(gestureRecognizer.view!.center.x > t) {
                    gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y:gestureRecognizer.view!.center.y )
                }else {
                    gestureRecognizer.view!.center = CGPoint(x:t, y:gestureRecognizer.view!.center.y)
                }
            }
            else
            {
                if(gestureRecognizer.view!.center.x < self.view.frame.width / 2 ) {
                    gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y )
                }else {
                    gestureRecognizer.view!.center = CGPoint(x: self.view.frame.width / 2, y: gestureRecognizer.view!.center.y)
                }
            }
            gestureRecognizer.setTranslation(CGPoint(x:0,y:0), in: self.view)
            
           
            
        }
        
        if(gestureRecognizer.state == UIGestureRecognizerState.ended)
        {
            if(gestureRecognizer.view!.center.x < (self.view.frame.width / 6))
            {
               
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                     gestureRecognizer.view!.center = CGPoint(x:-self.view.frame.width ,y:gestureRecognizer.view!.center.y)
                    gestureRecognizer.setTranslation(CGPoint(x:0,y:0), in: self.view)
                    
                }, completion: { finished in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuTapped"), object: nil)
                })
            }
            else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    gestureRecognizer.view!.center = CGPoint(x:self.view.frame.width / 2, y:gestureRecognizer.view!.center.y)
                    gestureRecognizer.setTranslation(CGPoint(x:0,y:0), in: self.view)
                    
                }, completion: { finished in
                    
                })
            }
        }
    }
    
    
    func showAnimation()  {
        self.view.frame.origin.x = 0
        self.view.isHidden = false
        self.m_TableviewLeadingcons.constant = -self.view.frame.size.width * 0.71
        self.m_menuTableView.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.m_TableviewLeadingcons.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (fininshed: Bool) -> () in
            if(fininshed == true) {
            }
        })
        
        
    }
    func hideAnimation(_view:UIView)  {
        self.m_TableviewLeadingcons.constant = 0
        self.m_menuTableView.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.m_TableviewLeadingcons.constant = -self.view.frame.size.width * 0.71
            _view.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (fininshed: Bool) -> () in
            if(fininshed == true) {
                self.view.isHidden = true
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func reloadMenu() {
      //  SDImageCache.shared().clearMemory()
      //  SDImageCache.shared().clearDisk()

        m_menuTableView.reloadData()
    }
    
    @objc func touchHandle()  {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuTapped"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



extension LeftMenuViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return menuItems.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headercell", for: indexPath) as! MenuHeaderCell

            cell.userNameLabel.text = self.keychain.get("name")
            cell.emaildLabel.text = self.keychain.get("emailId")
            
            let dataValue = self.keychain.getData("image")
            
            let image = UIImage(data: dataValue!)
            cell.profileImageView?.image = image

            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuItem", for: indexPath) as! MenuItemCell
            cell.setContent(title: menuItems[indexPath.row])
            cell.setImageContent(title: menuimageItems[indexPath.row])
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        }else {
            return 60
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if  indexPath.row == 1 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            navigationController?.pushViewController(newViewController, animated: true)
        }else{
            self.showAlertMessage(title: "", message: "Work in progress")
        }
    }
}
