//
//  Styling.swift
//  Fresh
//
//  Created by Richard Basdeo on 5/10/21.
//

import UIKit
class Styling {
    
    
    static func customButton (for aButton: UIButton){
        aButton.layer.cornerRadius = aButton.frame.height / 2
        aButton.backgroundColor = .black
        aButton.setTitleColor(.white, for: .normal)
    }
    
    static func labelStyle (styleLabel: UILabel, fontSize: CGFloat) {
        
    }
    
    static func textFieldStyle (textField: UITextField) {
        let bottomLine=CALayer();
        bottomLine.frame=CGRect(x:0,y:textField.frame.height-1,width:textField.frame.width,height:1)
        bottomLine.backgroundColor = UIColor.init(red:180/255,green: 151/255,blue:90/255,alpha: 1).cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
    
}
