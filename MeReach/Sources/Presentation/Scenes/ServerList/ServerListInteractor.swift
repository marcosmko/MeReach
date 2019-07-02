//
//  ServerListInteractor.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import UIKit.UIApplication
import RxCocoa
import RxSwift

protocol ServerListInteractorProtocol {
    func didLoad()
    func add(request: ServerList.AddNewServer.Request)
    func remove(request: ServerList.RemoveServer.Request)
}

protocol ServerListDataStore {
    var servers: BehaviorRelay<[(server: Server, isOnline: Bool)]> { get }
}

class ServerListInteractor: ServerListInteractorProtocol, ServerListDataStore {
    
    var presenter: ServerListPresenterProtocol?
    private var serverListWorker: ServerListWorker = ServerListWorker(serverListStore: ServerListAPI())
    private var serverWorkerProtocol: ServerWorkerProtocol = ServerCoreDataWorker()
    
    private var timer: Timer?
    private let lock: NSLock = NSLock()
    
    let servers: BehaviorRelay<[(server: Server, isOnline: Bool)]> = BehaviorRelay(value: [])
    
    func didLoad() {
        // fetch from persistence store
        let servers = try! self.serverWorkerProtocol.fetch().map({ ($0, false) })
        self.servers.accept(servers)
        
        // observe servers
        self.servers.asObservable()
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] servers in
                self.presenter?.present(response: ServerList.ServerStatus.Response(servers: servers))
            })
            .disposed(by: ReactManager.shared.disposeBag)
        
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
            guard !self.servers.value.contains(where: { $0.server.url == request.url }) else { return }
            
            // add url and ping
            let server = Server(url: request.url)
            self.servers.accept(self.servers.value + [(server, false)])
            try? self.serverWorkerProtocol.create(server)
            self.verify(url: request.url)
        })
        QueueManager.shared.executeBlock(blockForExecutionInBackground, queueType: .concurrent)
    }
    
    func remove(request: ServerList.RemoveServer.Request) {
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            var servers = self.servers.value
            let server = servers.remove(at: request.row)
            self.servers.accept(servers)
            try? self.serverWorkerProtocol.delete(server.server)
        })
        QueueManager.shared.executeBlock(blockForExecutionInBackground, queueType: .concurrent)
    }
    
    private func verify(url: URL) {
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            let isOnline: Bool = (try? self.serverListWorker.ping(url: url)) == true
            debugPrint("\(url.absoluteString) is \(isOnline ? "online" : "offline")")
            
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
