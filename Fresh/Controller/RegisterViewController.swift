//
//  RegisterViewController.swift
//  Fresh
//
//  Created by deion bacchus on 5/28/21.
//

import UIKit

class RegisterViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension RegisterViewController:RegisterUIUpdate{
    func successfullyRegistered(msg: String){
        print(msg)
    }
    func informUserErrorOccurred(errors:Array<ValidationResult>){
        DispatchQueue.main.async {
            
        }
    }
}
