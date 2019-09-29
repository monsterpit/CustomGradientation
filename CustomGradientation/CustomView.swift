//
//  CustomView.swift
//  CustomGradientation
//
//  Created by MB on 9/28/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class CustomView: UIView {

    private var isInterpolated : Bool = false
    
    private var gradientColors : [UIColor] = []
    
    private var selectedIndex : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    required init(colors : [String]  ,selectedIndex : Int = 0) {
        super.init(frame: CGRect.zero)
        
        self.selectedIndex = selectedIndex
        
        gradientColors = colors.map{$0.hexColor}
        
    }
    
    required init(colors : [UIColor]  ,selectedIndex : Int = 0) {
        super.init(frame: CGRect.zero)
        
        self.selectedIndex = selectedIndex
        
        gradientColors = colors.map{$0}
        
    }
    
    
    //MARK:- Create Gradient
    func gradientMaker(){
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x:0, y:0.5)
        gradient.endPoint = CGPoint(x:1, y:0.5)
        
        if !isInterpolated{
       // gradient.colors = [UIColor.red.cgColor,UIColor.red.cgColor, UIColor.orange.cgColor,UIColor.orange.cgColor]
        // First map creates a duplicate of each element
        // Second flatMap reduces [[1,1],[2,2]] to [1,1,2,2]
        // Third map is just used to convert UIColor to CGColor
        gradient.colors = gradientColors.map{[$0,$0]}.flatMap{$0}.map{$0.cgColor}
        
            
       //        gradient.locations = [0, 0.25,0.25,0.5,0.5,0.75,0.75,1]
       //We create a location array
        //then stride go from size of each element i.e if 4 elements i.e. 1/4 i.e. 0.25 to 1(excluding 1)
        // then First map creates a duplicate of each element
        // Second flatMap reduces [[1,1],[2,2]] to [1,1,2,2]
        // then we finally insert 0 at start position and 1 at last position
            
        var locations : [Float] = []
            
        let step : Float = 1/Float(gradientColors.count)
        for i in stride(from: step, to: 1, by: step) {
                locations.append(i)
        }
        
        locations = locations.map{[$0,$0]}.flatMap{$0}
        locations.insert(0,at : 0)
        locations.append(1)
            
        gradient.locations = locations as [NSNumber]
        
        }
        else{
            
        }
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK:- Create Rounded Corners
    func createRoundedCorners(radius : CGFloat){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    //Todo:- Create a Knob View
    func createKnobForSlider(knobSize : inout CGFloat) {
        
        
    
        let elementSize = ( frame.width * CGFloat( (1 / Float(gradientColors.count) ) ) )
        
        var knobViewX : CGFloat = 0
       
         //knobSize < rect.height ? knobSize * 2 : knobSize
        
        if knobSize > frame.height{
            knobViewX = frame.minX + (elementSize * CGFloat(selectedIndex )) + (elementSize/4)
        }
        else{
            knobViewX = frame.minX + (elementSize * CGFloat(selectedIndex ))
            knobSize = knobSize * 2
        }

        
        let knobViewY = frame.height < knobSize ? frame.minY - (knobSize - frame.height)/2 : frame.minY
        
        let knobView = UIView(frame: CGRect(x: knobViewX, y: knobViewY, width: knobSize, height: knobSize))
        knobView.layer.cornerRadius = knobView.frame.width/2
        
        knobView.clipsToBounds = true
        knobView.backgroundColor = .black
       // addSubview(knobView)
        
        print(knobView)
        
        superview?.addSubview(knobView)
        
//        knobView.translatesAutoresizingMaskIntoConstraints = false
//
//       // knobView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
//
//      //  knobView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
//
//        knobView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
//
//       // knobView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
//
//        knobView.heightAnchor.constraint(equalToConstant: knobView.frame.height).isActive = true
//
//        knobView.widthAnchor.constraint(equalToConstant: knobView.frame.width).isActive = true
        
    }
   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        gradientMaker()
        createRoundedCorners(radius: rect.height/2)
        
    
        
        var knobSize = ( rect.width * CGFloat( (1 / Float(gradientColors.count) ) )
            / 2 )
        
       
        createKnobForSlider(knobSize: &knobSize )
     
    }
 

}





extension String{
    
    var hexColor : UIColor{
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int = UInt32()
        
        Scanner(string: hex).scanHexInt32(&int)
        
        let a,r,g,b : UInt32
        
        switch hex.count{
        case 3: //RGB (12 Bit)
            (a,r,g,b) = (255, (int >> 8) * 17,(int >> 4 & 0xF) * 17 , (int & 0xF) * 17)
        case 6: //RGB (24 Bit)
            (a,r,g,b) = (255, (int >> 16),(int >> 8 & 0xFF) , (int & 0xFF) )
        case 8 : //RGB (32-bit)
            (a,r,g,b) = (int >> 24,(int >> 16 & 0xFF) ,(int >> 8 & 0xFF),(int & 0xFF))
        default:
            return .clear
        }
        
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
        
        
        
    }
}
