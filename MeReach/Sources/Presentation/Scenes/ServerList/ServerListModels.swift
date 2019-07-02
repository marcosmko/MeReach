//
//  ServerListModels.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

enum ServerList {
    
    enum AddNewServer {
        struct Request {
            let url: URL
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum RemoveServer {
        struct Request {
            let row: Int
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum ServerStatus {
        struct Request {
        }
        struct Response {
            let servers: [(Server, Bool)]
        }
        struct ViewModel {
            struct DisplayedServer {
                let url: String
                let isOnline: Bool
            }
            
            let displayedServers: [DisplayedServer]
        }
    }
}
