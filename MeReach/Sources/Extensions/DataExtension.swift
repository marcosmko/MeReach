//
//  DataExtension.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 04/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

#if DEBUG
public extension Data {
    
    /// Get the string of string data.
    public var stringValue: String? {
        if let  object = try? JSONSerialization.jsonObject(with: self, options: .allowFragments),
            let string = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]) {
            return String(data: string, encoding: .utf8)
        }
        return String(data: self, encoding: .utf8)
    }
    
    mutating func append(string: String?) {
        if let data = string?.data(using: .utf8, allowLossyConversion: false) {
            append(data)
        }
    }
    
}
#endif
