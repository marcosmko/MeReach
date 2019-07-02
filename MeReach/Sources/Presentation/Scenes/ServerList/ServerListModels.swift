//
//  ServerListModels.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

enum ServerList {
    
    struct DisplayedServer {
        let url: String
        let isOnline: Bool
    }
    
    enum AddNewServer {
        struct Request {
            let url: String?
        }
        struct Response {
            let isError: Bool
            let url: String
        }
        struct ViewModel {
            let displayedServer: DisplayedServer
        }
    }
    
    enum RemoveServer {
        struct Request {
            let row: Int
        }
        struct Response {
            let isError: Bool
            let url: String
        }
        struct ViewModel {
            let displayedServer: DisplayedServer
        }
    }
    
    enum ServerStatus {
        struct Response {
            let servers: [(Server, Bool)]
        }
        struct ViewModel {
            let displayedServers: [DisplayedServer]
        }
    }
}
