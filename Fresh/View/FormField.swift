//
//  FormField.swift
//  Fresh
//
//  Created by deion bacchus on 5/29/21.
//

import Foundation
import UIKit

class FormField{
    init(textField:UITextField){
        let bottomLine=CALayer();
        bottomLine.frame=CGRect(x:0,y:textField.frame.height-1,width:textField.frame.width,height:1)
        bottomLine.backgroundColor = UIColor.init(red:180/255,green: 151/255,blue:90/255,alpha: 1).cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
}
