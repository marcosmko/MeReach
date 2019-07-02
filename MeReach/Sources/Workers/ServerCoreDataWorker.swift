//
//  ServerCoreDataWorker.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import CoreData

class ServerCoreDataWorker {
    
    func fetch() throws -> [Server] {
        do {
            let request: NSFetchRequest<Server> = Server.fetchRequest()
            return try CoreDataManager.shared.fetch(request)
        } catch {
            throw NSError()
            // throw ChatError.database(description: error.localizedDescription)
        }
    }
    
    func create(_ server: Server) throws {
        do {
            try CoreDataManager.shared.insert(server)
        } catch {
            throw NSError()
            // throw ChatError.database(description: error.localizedDescription)
        }
    }
    
    func delete(_ server: Server) throws {
        do {
            try CoreDataManager.shared.delete(server)
        } catch {
            throw NSError()
            // throw ChatError.database(description: error.localizedDescription)
        }
    }
    
}
