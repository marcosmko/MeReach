//
//  ServerListInteractor.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import UIKit.UIApplication
import RxSwift
import RxCocoa

protocol ServerListInteractorProtocol {
    func didLoad()
    func add(request: ServerList.AddNewServer.Request)
    func remove(request: ServerList.RemoveServer.Request)
}

protocol ServerListDataStore {
    var servers: BehaviorRelay<[(server: Server, isOnline: Bool)]>  { get }
}

class ServerListInteractor: ServerListInteractorProtocol, ServerListDataStore {
    
    var presenter: ServerListPresenterProtocol?
    var serverListWorker: ServerListWorker = ServerListWorker(serverListStore: ServerListAPIDummy())
    var serverCoreDataWorker: ServerCoreDataWorker = ServerCoreDataWorker()
    
    var timer: Timer?
    let lock: NSLock = NSLock()
    
    let disposeBag: DisposeBag = DisposeBag()
    let servers: BehaviorRelay<[(server: Server, isOnline: Bool)]> = BehaviorRelay(value: [])
    
    func didLoad() {
        // fetch from persistence store
        let servers =  try! self.serverCoreDataWorker.fetch().map({ ($0, false) })
        self.servers.accept(servers)
        
        // observe servers
        self.servers.asObservable()
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] servers in
                self.presenter?.present(response: ServerList.ServerStatus.Response(servers: servers))
            })
            .disposed(by: self.disposeBag)
        
        // schedule timer
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { timer.invalidate() ; return }
            for (server, _) in self.servers.value {
                guard let url = server.url else { continue }
                self.verify(url: url)
            }
        })
        self.timer?.fire()
    }
    
    func add(request: ServerList.AddNewServer.Request) {
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            guard let string = request.url else { return }
            if let url = URL(string: string), !self.servers.value.contains(where: { $0.server.url == url }), UIApplication.shared.canOpenURL(url: url) {
                // add url and ping
                let server = Server(url: url)
                self.servers.accept(self.servers.value + [(server, false)])
                try! self.serverCoreDataWorker.create(server)
                self.verify(url: url)
            } else {
                // invalid url
                self.presenter?.present(response: ServerList.AddNewServer.Response(isError: true, url: ""))
            }
        })
        QueueManager.shared.executeBlock(blockForExecutionInBackground, queueType: .concurrent)
    }
    
    func remove(request: ServerList.RemoveServer.Request) {
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            var servers = self.servers.value
            let server = servers.remove(at: request.row)
            self.servers.accept(servers)
            try! self.serverCoreDataWorker.delete(server.server)
        })
        QueueManager.shared.executeBlock(blockForExecutionInBackground, queueType: .concurrent)
    }
    
    private func verify(url: URL) {
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            let isOnline: Bool
            if (try? self.serverListWorker.ping(url: url)) == true {
                print("\(url.absoluteString) is online")
                isOnline = true
            } else {
                print("\(url.absoluteString) is offline")
                isOnline = false
            }
            
            // as we are updating asynchronously, we need to lock resources
            if let index = self.servers.value.firstIndex(where: { return $0.server.url == url }) {
                self.lock.lock()
                var servers = self.servers.value
                servers[index].isOnline = isOnline
                self.servers.accept(servers)
                self.lock.unlock()
            }
        })
        QueueManager.shared.executeBlock(blockForExecutionInBackground, queueType: .concurrent)
    }
    
}

