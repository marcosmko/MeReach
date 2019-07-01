//
//  ServerListAPI.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

class ServerListAPI: API, ServerListStoreProtocol {
    
    func ping() -> ((URL) throws -> Bool) {
        return { url in
            return try API.request(request: Request.get(url: url)) != nil
        }
    }
    
}
