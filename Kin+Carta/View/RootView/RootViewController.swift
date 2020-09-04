//
//  RootViewController.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 21/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    //Data Source
    var viewModel: ContactsViewModel! = ContactsViewModel()
  
    //Root View
    var rootView: RootView {
        return view as! RootView
    }
    //MARK: - View Controller Life-cycle methods
    override func loadView() {
        super.loadView()
        let rootView = RootView(frame: .zero)
        rootView.delegate = self
        rootView.viewModel = viewModel
        view = rootView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.viewModelSetupAndFetch()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
    }
}
//MARK: - RootView Delegate methods
extension RootViewController: RootViewDelegate {
    func presentController(from view: UIView, viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, completion: nil)
    }
    func pushController(from view: UIView, viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
