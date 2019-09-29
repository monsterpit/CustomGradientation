//
//  ViewController.swift
//  CustomGradientation
//
//  Created by MB on 9/28/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var csView : CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
       // csView = CustomView(colors: ["#FF0000","#FFFF00","#0000ff","#FF0000","#FFFF00","#0000ff"], selectedIndex: 3 )
        
       csView = CustomView(colors: ["#FF0000","#FFFF00"], selectedIndex: 2 , isInterpolated : true)
        
        view.addSubview(csView)
        
        csView.translatesAutoresizingMaskIntoConstraints = false
        
        csView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        csView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        csView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        csView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //csView.backgroundColor = .red
        
        
//        let gradient = CAGradientLayer()
//        gradient.frame = self.view.bounds
//        gradient.startPoint = CGPoint(x:0, y:0)
//        gradient.endPoint = CGPoint(x:1, y:0)
//        gradient.colors = [UIColor.red.cgColor,UIColor.red.cgColor, UIColor.orange.cgColor,UIColor.orange.cgColor, UIColor.blue.cgColor,UIColor.blue.cgColor, UIColor.yellow.cgColor,UIColor.yellow.cgColor]
//        gradient.locations = [0, 0.25,0.25,0.5,0.5,0.75,0.75,1]
//        //self.view.layer.addSublayer(gradient)
//        self.view.layer.insertSublayer(gradient, at: 0)
    }


}

