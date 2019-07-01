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
    func display(viewModel: ServerList.AddNewServer.ViewModel.DisplayedServer)
    func errorAddingServer(viewModel: ServerList.AddNewServer.ViewModel)
}

class ServerListViewController: UIViewController, ServerListDisplayLogic {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var urlTextField: UITextField!
    
    var interactor: ServerListInteractorProtocol?
    var router: ServerListRouterProtocol?
    
    var displayedServers: [ServerList.AddNewServer.ViewModel.DisplayedServer] = []
    
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func add(_ sender: Any) {
        self.interactor?.add(request: ServerList.AddNewServer.Request(url: self.urlTextField.text))
    }
    
    func display(viewModel: ServerList.AddNewServer.ViewModel) {
        self.tableView.reloadData()
    }
    
    func display(viewModel: ServerList.AddNewServer.ViewModel.DisplayedServer) {
        self.urlTextField.text = ""
        self.urlTextField.textColor = UIColor.black
        self.displayedServers.append(viewModel)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.displayedServers[indexPath.row].url
        return cell
    }
    
}
