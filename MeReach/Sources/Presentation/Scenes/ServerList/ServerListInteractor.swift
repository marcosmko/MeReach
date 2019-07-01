//
//  ServerListInteractor.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol ServerListInteractorProtocol {
    // func fetch(request: Mars.FetchPhotos.Request)
}

protocol ServerListDataStore {
    // var photos: [Photo] { get }
}

class ServerListInteractor: ServerListInteractorProtocol, ServerListDataStore {
    var presenter: ServerListPresenterProtocol?
}

