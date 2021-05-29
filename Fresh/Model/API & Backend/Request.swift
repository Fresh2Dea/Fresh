//
//  Request.swift
//  Fresh
//
//  Created by deion bacchus on 5/15/21.
//

import Foundation

enum RequestError: Error {
    case UnknownNetworkError(String)
    case JSONError(String)
}

protocol requestProtocol {
    func onSuccess(status:Int,data:Data,response:URLResponse,requestMethod:String,endpoint:String)
    func onError(error:Error)
}

class Request{
    let url:String
    var delegate: requestProtocol?
    init(url:String){
        self.url=url
    }
    
    func createJSONBody(body:[String: Any])throws ->Data{
        var json:Data
        do {
            json = try JSONSerialization.data(withJSONObject: body, options: [])
            return json
        }
        catch {
            throw RequestError.JSONError("Failed To Convert Data To JSON")
        }
    }
    
    
    func requestWithBody(requestMethod:String,endpoint:String,body:[String: Any],headers:[String: String]){
        let url = URL(string: self.url + endpoint)
        var request = URLRequest(url: url!)
        do{
            let requestBody: Data?=try createJSONBody(body: body)
            request.httpBody = requestBody!
            request.httpMethod=requestMethod
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request){ Data, Response, Error in
                
                if let e = Error {
                    self.delegate?.onError(error: e)
                }else {
                    let statusCode = Response as! HTTPURLResponse
                    self.delegate?.onSuccess(status:statusCode.statusCode,data:Data!,response:Response!,requestMethod:requestMethod,endpoint:endpoint)
                }
            }
            
            task.resume()
        }catch{
            
        }
    }
    
    func post(endpoint:String,body:[String: Any],headers:[String: String]){
        return requestWithBody(requestMethod: "POST", endpoint: endpoint, body: body, headers: headers)
    }
}
