//
//  APIManager.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import Foundation
import UIKit

open class APIManager: NSObject {

    private var baseURL: String? = ""

    
    public static let shared = APIManager()
    
    public func setBaseURL(_ baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func getBaseURL() -> String {
        if let baseURL = self.baseURL {
            return baseURL
        }
        return ""
    }

    
    public func get(path: String, headers: [[String: String]]?, params: [String: Any]?, success: @escaping (Data) -> Void, failure: @escaping (Int, String) -> Void) {
    
        var paramsString: String = ""
        var urlVars: [String] = []
        if let dictionary = params {
            for (k,v) in dictionary {
                urlVars.append("\(k)=\(v)")
            }
            paramsString = urlVars.joined(separator: "&")
        }

        var url = "\(path)"
        
        if paramsString != "" {
            url = "\(path)?\(paramsString)"
        }
        
        var request  = URLRequest(url: URL(string: "\(self.baseURL ?? "")/\(url)")!)
        request.httpMethod = "GET"
        
        if let headers = headers {
            for dictionary in headers {
                for (key, value) in dictionary {
                   request.setValue(value, forHTTPHeaderField: key)
                }
                
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    failure(0, "")
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    failure(0, "")
                }
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    success(data)
                }
            } else {
                guard let e = error else {
                    DispatchQueue.main.async {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            if responseJSON.keys.contains("message") {
                                let message = responseJSON["message"] as! String
                                failure(response.statusCode, message)
                            } else {
                                failure(response.statusCode, "")
                            }
                        } else {
                            failure(response.statusCode, "")
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    failure(response.statusCode, e.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    public func post(path: String, headers: [[String: String]]?, params: Data?, success: @escaping (Data) -> Void, failure: @escaping (Int, String) -> Void) {
        var request  = URLRequest(url: URL(string: "\(self.baseURL ?? "")/\(path)")!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 300
        

        if let headers = headers {
            for dictionary in headers {
                request.setValue(dictionary["value"], forHTTPHeaderField: dictionary["key"]!)
            }
        }
        
        if let data = params {
            request.httpBody = data
        }
        
        URLSession.shared.configuration.timeoutIntervalForResource = 3000000
        URLSession.shared.configuration.timeoutIntervalForRequest = 3000000
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                failure(0, "")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                failure(0, "")
                return
            }
            
            if response.statusCode == 200 {
                success(data)
            } else {
                guard let e = error else {
                    DispatchQueue.main.async {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            if responseJSON.keys.contains("message") {
                                let message = responseJSON["message"] as! String
                                failure(response.statusCode, message)
                            } else {
                                failure(response.statusCode, "")
                            }
                        } else {
                            failure(response.statusCode, "")
                        }
                    }
                    return
                }
                failure(response.statusCode, e.localizedDescription)
            }
        }
        task.resume()
    }
}
