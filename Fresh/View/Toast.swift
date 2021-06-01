//
//  Toast.swift
//  Fresh
//
//  Created by deion bacchus on 5/31/21.
//

import Foundation
import UIKit

struct Toast{
    func showToast(message : String,view: UIViewController) {
        let width = view.view.frame.size.width-(2*(view.view.frame.size.width/4 - 75))
        
        //First need toast off the sceen so y is + 100
        let toastLabel = UILabel(frame: CGRect(x: view.view.frame.size.width/4 - 75,
                                               y: view.view.frame.size.height + 100,
                                               width: width,
                                               height: 50))
        
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.view.addSubview(toastLabel)
        
        //Now need animation to appear on screen so - 100 in y
        UIView.animate(withDuration: 0.5) {
            toastLabel.frame = CGRect(x: view.view.frame.size.width/4 - 75,
                                      y: view.view.frame.size.height-100,
                                      width: width,
                                      height: 50)
        } completion: { _ in
            
            //Now get rid of the animations from the screen and remove it from the view
            UIView.animate(withDuration: 2,
                           delay: 1,
                           options: .curveLinear) {
                toastLabel.frame = CGRect(x: view.view.frame.size.width/4 - 75,
                                          y: view.view.frame.size.height + 100,
                                          width: width,
                                          height: 50)
            } completion: { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
