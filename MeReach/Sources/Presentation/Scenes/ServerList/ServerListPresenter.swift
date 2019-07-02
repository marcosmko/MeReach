//
//  ServerListPresenter.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol ServerListPresenterProtocol {
    func present(response: ServerList.ServerStatus.Response)
}

class ServerListPresenter: ServerListPresenterProtocol {
    
    weak var viewController: ServerListDisplayLogic?
    
    func present(response: ServerList.ServerStatus.Response) {
        let blockForExecutionInMainThread: BlockOperation = BlockOperation(block: {
            var displayedServers: [ServerList.DisplayedServer] = []
            for (server, isOnline) in response.servers {
                guard let url = server.url?.absoluteString else { continue }
                displayedServers.append(ServerList.DisplayedServer(url: url, isOnline: isOnline))
            }
            self.viewController?.display(viewModel: ServerList.ServerStatus.ViewModel(displayedServers: displayedServers))
        })
        QueueManager.shared.executeBlock(blockForExecutionInMainThread, queueType: .main)
    }
    
}
