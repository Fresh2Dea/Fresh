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
        let width=view.view.frame.size.width-(2*(view.view.frame.size.width/4 - 75))
        let toastLabel = UILabel(frame: CGRect(x: view.view.frame.size.width/4 - 75, y: view.view.frame.size.height-100, width: width, height: 50))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 9.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 3;
        toastLabel.clipsToBounds  =  true
        view.view.addSubview(toastLabel)
        /*
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
        })
 */
    }
}
