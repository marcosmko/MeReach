//
//  URLSessionExtension.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

extension URLSession {
    
    func performSynchronousRequest(_ request: URLRequest) -> (data: Data?, response: HTTPURLResponse?, error: Error?) {
        var serverData: Data?
        var serverResponse: URLResponse?
        var serverError: Error?
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            serverData = data
            serverResponse = response
            serverError = error
            
            semaphore.signal()
        }).resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return (serverData, serverResponse as? HTTPURLResponse, serverError)
    }
    
}

import UIKit

extension UIApplication {
    
    func canOpenURL(url: URL) -> Bool {
        var canOpen: Bool = false
        DispatchQueue.main.sync {
            canOpen = self.canOpenURL(url)
        }
        return canOpen
    }
}
