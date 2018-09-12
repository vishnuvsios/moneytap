//
//  HomeViewController.swift
//  wikipedia
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//



import UIKit

extension UIView{
    
    
    func makeViewCircular(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true

    }
    
    func makeRoundedCorners(borderColor:UIColor = UIColor.clear, borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.height/2.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }


}
