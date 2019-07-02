//
//  Server.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import CoreData

class Server: NSManagedObject {
    
    @NSManaged var url: URL?
    var isOnline: Bool = false
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Server> {
        return NSFetchRequest<Server>(entityName: String(describing: self))
    }
    
    convenience init(url: URL) {
        let entityDescription: NSEntityDescription = CoreDataManager.shared.create(String(describing: type(of: self)))
        self.init(entity: entityDescription, insertInto: nil)
        self.url = url
    }
    
}
