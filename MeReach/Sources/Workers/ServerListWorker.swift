//
//  ServerListWorker.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

class ServerListWorker {
    
    private(set) var serverListStore: ServerListStoreProtocol
    
    init(serverListStore: ServerListStoreProtocol) {
        self.serverListStore = serverListStore
    }
    
    func ping(url: URL) throws -> Bool {
        return try self.serverListStore.ping()(url)
    }
    
}

// MARK: - Server List API

protocol ServerListStoreProtocol {
    func ping() -> ((_ url: URL) throws -> Bool)
}
