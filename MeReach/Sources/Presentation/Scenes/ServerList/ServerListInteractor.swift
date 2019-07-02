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
    func didLoad()
    func add(request: ServerList.AddNewServer.Request)
    func remove(request: ServerList.RemoveServer.Request)
}

protocol ServerListDataStore {
    var servers: [Server] { get }
}

class ServerListInteractor: ServerListInteractorProtocol, ServerListDataStore {
    
    var presenter: ServerListPresenterProtocol?
    var serverListWorker = ServerListWorker(serverListStore: ServerListAPI())
    var serverCoreDataWorker = ServerCoreDataWorker()
    
    var timer: Timer?
    var servers: [Server] = [] {
        didSet { self.presenter?.present(response: ServerList.ServerStatus.Response(servers: self.servers)) }
    }
    
    func didLoad() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { timer.invalidate() ; return }
            for server in self.servers {
                guard let url = server.url else { continue }
                self.verify(url: url)
            }
        })
        self.servers = try! self.serverCoreDataWorker.fetch()
    }
    
    func add(request: ServerList.AddNewServer.Request) {
        guard let string = request.url else { return }
        if let url = URL(string: string), !self.servers.contains(where: { $0.url == url }), UIApplication.shared.canOpenURL(url) {
            // add url and ping
            let server = Server(url: url)
            self.servers.append(server)
            try! self.serverCoreDataWorker.create(server)
            self.verify(url: url)
        } else {
            // invalid url
            self.presenter?.present(response: ServerList.AddNewServer.Response(isError: true, url: ""))
        }
    }
    
    func remove(request: ServerList.RemoveServer.Request) {
        let server = self.servers.remove(at: request.row)
        try! self.serverCoreDataWorker.delete(server)
    }
    
    func verify(url: URL) {
        if try! serverListWorker.ping(url: url) {
            print("\(url.absoluteString) is online")
            // self.urls[url] = true
        } else {
            print("\(url.absoluteString) is offline")
            // self.urls[url] = false
        }
    }
    
}

