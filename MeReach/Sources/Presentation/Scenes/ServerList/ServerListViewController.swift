//
//  ViewController.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit

protocol ServerListDisplayLogic: class {
    func display(viewModel: ServerList.AddNewServer.ViewModel)
    func display(viewModel: ServerList.ServerStatus.ViewModel)
    func errorAddingServer(viewModel: ServerList.AddNewServer.ViewModel)
}

class ServerListViewController: UIViewController, ServerListDisplayLogic {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var urlTextField: UITextField!
    
    var interactor: ServerListInteractorProtocol?
    var router: ServerListRouterProtocol?
    
    var displayedServers: [ServerList.DisplayedServer] = []
    
    private func setup() {
        let viewController = self
        let interactor = ServerListInteractor()
        let presenter = ServerListPresenter()
        let router = ServerListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor?.didLoad()
    }
    
    @IBAction private func add(_ sender: Any) {
        self.interactor?.add(request: ServerList.AddNewServer.Request(url: self.urlTextField.text))
    }
    
    func display(viewModel: ServerList.AddNewServer.ViewModel) {
        self.urlTextField.text = "http://"
        self.urlTextField.textColor = UIColor.black
        self.displayedServers.append(viewModel.displayedServer)
        self.tableView.reloadData()
    }
    
    func display(viewModel: ServerList.ServerStatus.ViewModel) {
        self.displayedServers = viewModel.displayedServers
        self.tableView.reloadData()
    }
    
    func errorAddingServer(viewModel: ServerList.AddNewServer.ViewModel) {
        self.urlTextField.textColor = UIColor.red
    }
    
}

extension ServerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedServers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.displayedServers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.url
        cell.backgroundColor = viewModel.isOnline ? UIColor.green : UIColor.red
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            self.displayedServers.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.interactor?.remove(request: ServerList.RemoveServer.Request(row: indexPath.row))
        }
    }
    
}
