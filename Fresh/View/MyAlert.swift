//
//  MyAlert.swift
//  Restaurant Recommendations
//
//  Created by Richard Basdeo on 5/17/21.
//

import UIKit
class MyAlert {
    
    //This will be the alpha of the background view that will cover the current viewController
    static let alphaTurnInto: CGFloat = 0.6
    
    //Create the background view to dim the currentViewController
    
    private let backgroundView: UIView = {
        
        //The view that will hold customizations of the background view
        let returnView = UIView()
        
        //Want backgroundView to be black
        returnView.backgroundColor = .black
        
        //Dont want view visible at first
        returnView.alpha = 0

        return returnView
        
    }()
    
    //Create another view that will be the alert
    private let alert: UIView = {
        
        let returnAlert = UIView()
        
        returnAlert.backgroundColor = #colorLiteral(red: 0.1391222775, green: 0.1981398463, blue: 0.2276092172, alpha: 1)
        
        //round corners
        returnAlert.layer.masksToBounds = true
        returnAlert.layer.cornerRadius = 12
        
        return returnAlert
    }()
    
    
    
    
    
    
    
    //Function to present alert
    
    func presentAlert (title: String,
                       message: String,
                       viewController: UIViewController,
                       completionHandler: @escaping () -> ()) {
        
        
        //1. Get the viewController boundraries
        guard let targetView = viewController.view else {return}
        
        //2. Add the background and alert to the viewController
        //Make the backgroundView cover up the entire viewController
        backgroundView.frame = targetView.bounds
        
        targetView.addSubview(backgroundView)
        targetView.addSubview(alert)
        
        //Give the alertView frames
        //Is -300 Becuse we want it off the screen
        alert.frame = CGRect(x: targetView.frame.size.width/4,
                             y: -300,
                             width: targetView.frame.size.width / 2,
                             height: 100)
        
        //Create label titleLable to be added to alertView
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                               width: alert.frame.size.width,
                                               height: 30))
        titleLabel.text = title
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.backgroundColor = #colorLiteral(red: 0.1391222775, green: 0.1981398463, blue: 0.2276092172, alpha: 1)
        titleLabel.textAlignment = .center
        alert.addSubview(titleLabel)
        
        //Create message label
        //Create label titleLable to be added to alertView
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 20,
                                               width: alert.frame.size.width,
                                               height: 70))
        messageLabel.text = message
        messageLabel.backgroundColor = .white
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        alert.addSubview(messageLabel)
        
        
        
        
        
        
        
        
    
        
        
        
        //Animations to show alert
        UIView.animate(withDuration: 0.25) {
            
            
            //First want to change backgroundView alpha to blur out current viewController
            self.backgroundView.alpha = MyAlert.alphaTurnInto
            
            
        } completion: { (done) in
            
            //Now want to bring in alertView from the top
            //Animation to bring in alertView
            //Can do this by changing the frames
            UIView.animate(withDuration: 1) {
                
                self.alert.center = targetView.center
                
                
            } completion: { (done) in
                
                //When this is done now get rid of alert
                var delayTime: TimeInterval = 0
                
                if (done) {
                    delayTime = 1
                }
                
                UIView.animate(withDuration: 1, delay: delayTime) {
                    
                    //Get rid of alert
                    self.alert.frame = CGRect(x: targetView.frame.size.width/4,
                                              y: targetView.frame.size.height,
                                              width: targetView.frame.size.width / 4,
                                              height: 100)
                    
                    //Get rid of blur
                    self.backgroundView.alpha = 0
                    
                    
                } completion: { (done) in
                    
                    
                    
                    
                    if (done) {
                        
                        //Remove subviews
                        self.alert.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        messageLabel.text = ""
                        titleLabel.text = ""
                        completionHandler()
                        
                    }
   
                }
  
            }

        }
    }
}
