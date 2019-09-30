//
//  ViewController.swift
//  CustomGradientation
//
//  Created by MB on 9/28/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var csView : CustomSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //   csView = CustomSliderView(colors: ["#FF0000","#FFFF00","#0000ff","#FF0000","#FFFF00","#0000ff"], selectedIndex: 3 )
        
        csView = CustomSliderView(colors: ["#FF0000","#FFFF00"], selectedIndex: 2 , isInterpolated : true,interpolationValue: 1)
        
        view.addSubview(csView)
        
        csView.translatesAutoresizingMaskIntoConstraints = false
        
        csView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        csView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        csView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        csView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        csView.delegate = self
    }


}

extension ViewController : CustomSliderViewDelegate{

    func willSelectElement(index: Int, color: UIColor?) {
        print(index )
        if color != nil{
            //  view.backgroundColor = color
        }
    }
    
}
