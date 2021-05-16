//
//  Networking.swift
//  Fresh
//
//  Created by Richard Basdeo on 5/13/21.
//

import UIKit

protocol networkingProtocol {
    func loginSuccess(user: CurrentUser)
    func registerSuccess()
    func registerSuccess2()
    func error (message: String)
}

class Networking {
    
    var delegate: networkingProtocol?
    
    func attemptRegister (email: String, password: String, userName: String){
        
        //Register url as a string
        let registerURLString = "https://fresh2death.herokuapp.com/register"
        
        //Turn string to a url for networking
        guard let registerURL = URL(string: registerURLString) else {
            delegate?.error(message: "Something went wrong.")
            return
        }
        
        // convert parameters as a json for the body of the post request
        let requestedParameters : [String: String] = ["username": userName, "email": email, "password": password]
        
        var jsonData: Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: requestedParameters, options: [])
        }
        catch {
            delegate?.error(message: "Something went wrong.")
            return
        }
        
        //Configure request
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        //Create the Session
        let session = URLSession(configuration: .default)

        //Give the session a task
        let task = session.dataTask(with: request) { Data, Response, Error in
            if let e = Error {
                self.delegate?.error(message: "\(e.localizedDescription)")
            }
            else {
            
                let statusCode = Response as! HTTPURLResponse
                switch statusCode.statusCode {
                case 200...210:
                    self.delegate?.registerSuccess()
                default:
                    self.delegate?.error(message: "Register Unsuccesful.")
                }
            }
        }
        
        //Run the task
        task.resume()
    }
    
    
    
    func attemptLogin (email: String, Password: String){
        
        //Login url as a string
        let registerURLString = "https://fresh2death.herokuapp.com/login"
        
        //Turn string to a url
        guard let loginURL = URL(string: registerURLString) else {
            print("Nope")
            return
        }
        
        //Convert paramerts as a json for the request body
        let requestedParameters : [String: String] = ["email": email, "password": Password]
        
        var jsonData: Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: requestedParameters, options: [])
        }
        catch {
            print("Could not convert to json")
            return
        }
        
    
        //Configure request
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        //Create session
        let session = URLSession(configuration: .default)

        //Give sessoin a task
        let task = session.dataTask(with: request) { Data, Response, Error in
            
            //If there is a error print it
            if let e = Error {
                self.delegate?.error(message: e.localizedDescription)
            }
            //If no error parse returned data and create new Current user to be returned
            else {
                let statusCode = Response as! HTTPURLResponse
                switch statusCode.statusCode {
                case 200...210:
                    self.loginParse(dataReturned: Data)
                default:
                    self.delegate?.error(message: "Login Unsuccesful.")
                }
            }
        }
        task.resume()
    }
    
    //Parse returned data and create new current user and return to whoever.
    func loginParse(dataReturned: Data?) {
        
        guard let returned = dataReturned else {
            delegate?.error(message: "Something went wrong")
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(loginSuccess.self, from: returned)
            
            let signedInUser = CurrentUser(userId: decodedData.id, userName: decodedData.username, Posts: [], accessToken: decodedData.token, followers: [], following: [])
            
            //Return the current user
            delegate?.loginSuccess(user: signedInUser)
            
        }
        catch {
            delegate?.error(message: "Error pasrsing data")
        }
    }
}


