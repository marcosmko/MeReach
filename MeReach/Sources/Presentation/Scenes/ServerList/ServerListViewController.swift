//
//  ViewController.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 01/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit

protocol ServerListDisplayLogic: class {
    
}

class ServerListViewController: UIViewController, ServerListDisplayLogic {
    
    @IBOutlet private var tableView: UITableView!
    
    var interactor: ServerListInteractorProtocol?
    var router: ServerListRouterProtocol?
    
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
    
}
