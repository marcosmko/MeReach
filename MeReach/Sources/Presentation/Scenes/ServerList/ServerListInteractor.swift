//
//  ServerListInteractor.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import UIKit.UIApplication

protocol ServerListInteractorProtocol {
    func add(request: ServerList.AddNewServer.Request)
}

protocol ServerListDataStore {
    var urls: [URL] { get }
}

class ServerListInteractor: ServerListInteractorProtocol, ServerListDataStore {
    
    var presenter: ServerListPresenterProtocol?
    var serverListWorker = ServerListWorker(serverListStore: ServerListAPI())
    
    var urls: [URL] = []
    var timer: Timer?
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { timer.invalidate() ; return }
            for url in self.urls {
                self.verify(url: url)
            }
        })
    }
    
    func add(request: ServerList.AddNewServer.Request) {
        guard let string = request.url else { return }
        if let url = URL(string: string), !self.urls.contains(url), UIApplication.shared.canOpenURL(url) {
            // add url and ping
            self.urls.append(url)
            self.presenter?.present(response: ServerList.AddNewServer.Response(isError: false, url: string))
        } else {
            // invalid url
            self.presenter?.present(response: ServerList.AddNewServer.Response(isError: true, url: ""))
        }
    }
    
    func verify(url: URL) {
        if try! serverListWorker.ping(url: url) {
            print("\(url.absoluteString) is online")
        } else {
            print("\(url.absoluteString) is offline")
        }
    }
    
}

