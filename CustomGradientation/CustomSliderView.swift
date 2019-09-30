//
//  CustomSliderView.swift
//  CustomGradientation
//
//  Created by Vikas Salian on 9/28/19.
//  Copyright © 2019 Vikas Salian. All rights reserved.
//

import UIKit

@objc protocol CustomSliderViewDelegate : class{
    func willSelectElement(index : Int,color : UIColor?)
    @objc optional func didSelectElement(index : Int, color : UIColor?)
}



class CustomSliderView: UIView {

    private var isInterpolated : Bool = false
    
    private var gradientColors : [UIColor] = []
    
    private var selectedIndex : Int = 0
    
    private var knobView : UIView!
    
    private var isInitialSetupDone : Bool = false
    
    private var padding : CGFloat = 0
    
    private var elementSize : CGFloat = 0
    
    private var locations : [Float] = []
    
    private var interpolationValueDiff : Float = 0
    
    weak var delegate : CustomSliderViewDelegate?
    
    func createLocationsArray(){
        
        if !isInterpolated{
            let step : Float = 1/Float(gradientColors.count)
            for i in stride(from: Float(0), through: Float(1), by: step) {
                locations.append(i)
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    required init(colors : [String]  ,selectedIndex : Int = 0 ,isInterpolated : Bool = false ,interpolationValue : Int = 1) {
        super.init(frame: CGRect.zero)
        

        
        self.isInterpolated = isInterpolated
        
        if isInterpolated{
            createInterpolationRange(n: interpolationValue + 1)
        }
        
        self.selectedIndex = selectedIndex < colors.count || selectedIndex < locations.count ? selectedIndex : 0
        
        gradientColors = colors.map{$0.hexColor}
        
    }
    
    required init(colors : [UIColor]  ,selectedIndex : Int = 0 ,isInterpolated : Bool = false,interpolationValue : Int = 1) {
        super.init(frame: CGRect.zero)

        self.isInterpolated = isInterpolated
        
        if isInterpolated{
            createInterpolationRange(n: interpolationValue + 1)
        }
        
        self.selectedIndex = selectedIndex < colors.count || selectedIndex < locations.count ? selectedIndex : 0
        
        
        gradientColors = colors.map{$0}
        
    }
    
    //MARK:- breaking a mathematical range in equal parts
    //Creating locations for interpolation Layer for stops
    func createInterpolationRange(n : Int){
        
        let startValue : Float = 0
        let endValue : Float = 1
        interpolationValueDiff = (endValue-startValue)/Float(n)
        var element : Float = 0
        locations.append(element)
        for _ in 1...n{
            element = element + interpolationValueDiff
            locations.append(element)
        }
        
        
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
            gradient.colors = gradientColors.map{$0.cgColor}
            
        }
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK:- Create Rounded Corners
    func createRoundedCorners(radius : CGFloat){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    //Todo:- Create a Knob View
    func createKnobForSlider(strokeColor : UIColor = .white , strokeWidth : CGFloat = 0 , backgroundColor : UIColor = .clear,shadowColor : UIColor = .darkGray) {
        
        //Setting Frame For KnobView

        elementSize = ( frame.width * CGFloat( (1 / Float( isInterpolated ?  locations.count : gradientColors.count) ) ) )
        
        
        var knobSize : CGFloat = elementSize/2
        
        var knobViewX : CGFloat = 0
       
        var knobViewY : CGFloat = 0
        
        //If we Knob Size is greater than frame
        if knobSize > frame.height{
            padding =  (elementSize/4)
            knobViewX = frame.minX + (elementSize * CGFloat(selectedIndex )) + padding
            knobViewY =  frame.minY - ((knobSize - frame.height)/2)
        }
        else{
            padding = 0
            knobViewX = frame.minX + (elementSize * CGFloat(selectedIndex )) + padding
            knobSize = knobSize * 2
            knobViewY = frame.minY + ((frame.height - knobSize) / 2)
           
        }
        
        if  isInterpolated{
            let knobExtraHeight : CGFloat = 20
            knobSize = frame.height + knobExtraHeight
            knobViewX = frame.minX + (elementSize * CGFloat(selectedIndex )) + padding
            knobViewY = frame.minY + ((frame.height - knobSize) / 2)
            if selectedIndex == 0 {
                knobViewX = frame.minX
            }
            else if selectedIndex == (locations.count - 1){
                knobViewX = frame.maxX - knobSize
            }
            
        }

        
        knobView = UIView(frame: CGRect(x: knobViewX, y: knobViewY, width: knobSize, height: knobSize))
        
        //Design For KnobView
        knobView.layer.cornerRadius = knobView.frame.width/2
        knobView.layer.borderWidth =   strokeWidth == 0 ?  knobView.frame.width/8 : strokeWidth
        knobView.layer.borderColor = strokeColor.cgColor
        knobView.layer.shadowColor = shadowColor.cgColor
        knobView.layer.shadowOpacity = 1
        knobView.layer.shadowRadius = 10
        
      //  knobView.clipsToBounds = true
        knobView.backgroundColor = .clear

        superview?.addSubview(knobView)
        
        //Setting Gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        //self.addGestureRecognizer(panGesture)
        knobView.addGestureRecognizer(panGesture)
        
        //Tap Gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handlePan(sender panGesture: UIPanGestureRecognizer) {
        

        
       if panGesture.state == .changed {
            let location: CGPoint = panGesture.location(in: self)
            
             moveKnobToIndex(point : location)

        }
        
    }
    
    
    @objc
    func handleTap(sender tapGesture : UITapGestureRecognizer){
        
        if tapGesture.state == .ended{
            
            let location : CGPoint = tapGesture.location(in: self)
            
             moveKnobToIndex(point : location)
            
        }
        
    }
    
    
    func getIndexFromPosition(at : CGPoint) -> Int?{
      
        let x = Float(at.x / frame.width)
        
        var currentIndex = selectedIndex
        
        if ( x < 0 || x > 1) {
            return nil
        }

        
        
        if isInterpolated{
            
            for (index,element) in locations.enumerated(){

                 if index == 0{
                    
                    if (Float(at.x / frame.width) <= (element + (interpolationValueDiff/Float(2))  ) ){
                        currentIndex = (index)
                       
                        break
                    }
                    
                }
                else if index == locations.count - 1{
                    
                    if (Float(at.x / frame.width) >= (element - (interpolationValueDiff/Float(2))  ) ){
                        currentIndex = (index)
                        
                        break
                    }
                    //(Float(at.x / frame.width)
                }
                else if  ((element - (interpolationValueDiff/Float(2)))..<(element + (interpolationValueDiff/Float(2)))).contains(Float(at.x / frame.width)){
                    
                    currentIndex = (index)
                    break
                }
                
                
            }
            
            return currentIndex
        }
        
        else{
            
            for (index,element) in locations.enumerated(){
                if (Float(at.x / frame.width) <= element){
                    currentIndex = (index-1)
                    break
                }
            }
       
            if currentIndex == -1 || currentIndex >= locations.count-1{
                return nil
            }
 
            return currentIndex
            
            
        }
    }
    
    
    func moveKnobToIndex(point : CGPoint){
        
        
        guard let index : Int  = getIndexFromPosition(at: point) else {return}

        if index != selectedIndex{
            selectedIndex = index
            
            
            self.delegate?.willSelectElement(index: self.selectedIndex, color: self.isInterpolated ? nil : self.gradientColors[self.selectedIndex])
            
            UIView.animate(withDuration: 0.3, animations: {
                [weak self] in
                guard let `self` = self else {return}
                
                if self.isInterpolated{
                    
                    if index == 0 {
                        self.knobView.frame.origin.x = self.frame.minX
                    }
                    else if index == self.locations.count - 1{
                        
                        self.knobView.frame.origin.x = self.frame.maxX - self.knobView.frame.width
                    }
                    else{
                        self.knobView.frame.origin.x = self.frame.minX + (self.elementSize * CGFloat(self.selectedIndex )) + self.padding
                    }
                    
                    
                }
                else{
                    
                    self.knobView.frame.origin.x = self.frame.minX + (self.elementSize * CGFloat(self.selectedIndex )) + self.padding
                    
                }
                
                
            }) { (bool) in

                self.delegate?.didSelectElement?(index: self.selectedIndex, color: self.isInterpolated ? nil : self.gradientColors[self.selectedIndex])
                
            }
            
           // UIView.animate(withDuration: 0.3)
        }
    }
    
    


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if !isInitialSetupDone {
        createLocationsArray()
        
        gradientMaker()
        createRoundedCorners(radius: rect.height/2)
        createKnobForSlider( )
        isInitialSetupDone.toggle()
        }
        
        
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
