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
            let url: String?
        }
        struct Response {
            let isError: Bool
            let url: String
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
