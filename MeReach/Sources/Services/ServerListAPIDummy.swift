//
//  ServerListAPIDummy.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 02/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

class ServerListAPIDummy: API, ServerListStoreProtocol {
    
    func ping() -> ((URL) throws -> Bool) {
        return { _ in
            return  Int(arc4random_uniform(10)) < 8
        }
    }
    
}
