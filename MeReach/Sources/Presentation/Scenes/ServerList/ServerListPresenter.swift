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
}

class ServerListPresenter: ServerListPresenterProtocol {
    weak var viewController: ServerListDisplayLogic?
    
    func present(response: ServerList.AddNewServer.Response) {
        if response.isError {
            self.viewController?.errorAddingServer(viewModel: ServerList.AddNewServer.ViewModel(displayedServers: []))
        } else {
            self.viewController?.display(viewModel: ServerList.AddNewServer.ViewModel.DisplayedServer(url: response.url, isOnline: false))
        }
    }
}
