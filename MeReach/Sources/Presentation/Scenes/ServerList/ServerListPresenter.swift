//
//  ServerListPresenter.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol ServerListPresenterProtocol {
    func present(response: ServerList.AddNewServer.Response)
    func present(response: ServerList.ServerStatus.Response)
}

class ServerListPresenter: ServerListPresenterProtocol {
    weak var viewController: ServerListDisplayLogic?
    
    func present(response: ServerList.AddNewServer.Response) {
        if response.isError {
            self.viewController?.errorAddingServer(viewModel: ServerList.AddNewServer.ViewModel(displayedServer: ServerList.DisplayedServer(url: "", isOnline: false)))
        } else {
            self.viewController?.display(viewModel: ServerList.AddNewServer.ViewModel(displayedServer: ServerList.DisplayedServer(url: response.url, isOnline: false)))
        }
    }
    
    func present(response: ServerList.ServerStatus.Response) {
        var displayedServers: [ServerList.DisplayedServer] = []
        for server in response.servers {
            guard let url = server.url?.absoluteString else { continue }
            displayedServers.append(ServerList.DisplayedServer(url: url, isOnline: server.isOnline))
        }
        self.viewController?.display(viewModel: ServerList.ServerStatus.ViewModel(displayedServers: displayedServers))
    }
    
}
