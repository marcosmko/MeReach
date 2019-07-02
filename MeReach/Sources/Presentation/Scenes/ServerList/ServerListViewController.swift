//
//  ViewController.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol ServerListDisplayLogic: class {
    func display(viewModel: ServerList.ServerStatus.ViewModel)
}

class ServerListViewController: UIViewController, ServerListDisplayLogic {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var urlTextField: UITextField!
    @IBOutlet private var addButton: UIButton!
    
    var interactor: ServerListInteractorProtocol?
    var router: ServerListRouterProtocol?
    
    var displayedServers: BehaviorRelay<[ServerList.DisplayedServer]> = BehaviorRelay(value: [])
    
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
        self.setupTextField()
        self.setupTable()
        self.setupAddButton()
    }
    
    private func setupTable() {
        self.displayedServers
            .bind(to: self.tableView
                .rx
                .items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                    row, server, cell in
                    
                    cell.textLabel?.text = server.url
                    cell.backgroundColor = server.isOnline ? UIColor.green : UIColor.red
            }
            .disposed(by: ReactManager.shared.disposeBag)
        
        self.tableView.rx
            .itemDeleted
            .subscribe(onNext: { (indexPath) in
                self.interactor?.remove(request: ServerList.RemoveServer.Request(row: indexPath.row))
            })
            .disposed(by: ReactManager.shared.disposeBag)
    }
    
    private func setupTextField() {
        self.urlTextField.rx
            .text
            .subscribe(onNext: { (text) in
                guard let text = text, let url = URL(string: text), UIApplication.shared.canOpenURL(url) else {
                    self.addButton.isEnabled = false
                    return
                }
                self.addButton.isEnabled = true
            })
            .disposed(by: ReactManager.shared.disposeBag)
    }
    
    private func setupAddButton() {
        self.addButton.rx.tap
            .subscribe(onNext: { (_) in
                guard let url = URL(string: self.urlTextField.text ?? "") else { return }
                self.interactor?.add(request: ServerList.AddNewServer.Request(url: url))
            })
            .disposed(by: ReactManager.shared.disposeBag)
    }
    
    func display(viewModel: ServerList.ServerStatus.ViewModel) {
        self.displayedServers.accept(viewModel.displayedServers)
        self.tableView.reloadData()
    }
    
}
