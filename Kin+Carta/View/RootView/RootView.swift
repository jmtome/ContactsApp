//
//  RootView.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 03/09/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

//MARK: - RootViewDelegate Protocol
protocol RootViewDelegate: class {
    func pushController(from view: UIView, viewController: UIViewController, animated: Bool)
    func presentController(from view: UIView, viewController: UIViewController, animated: Bool)
}

class RootView: UIView {
    //MARK: - Delegate
    weak var delegate: RootViewDelegate?
    
    //MARK: - ViewModel Property
    var viewModel: ContactsViewModel!
    
    //MARK: - UI Properties
    var tableView = UITableView(frame: .zero, style: .plain)
    var activityIndicator: UIActivityIndicatorView!
    //Refresher
    var refreshControl = UIRefreshControl()
    
    //TableView Reuse Identifiers
    let reuseIdentifier = "RootCellID"
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupActivityIndicator()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Public Methods
extension RootView {
    // Initial page settings
    func viewModelSetupAndFetch()  {
        //whenever the update closure is triggered inside the ContactsViewModel class, the tableview will be reloaded
        if viewModel?.update == nil {
            viewModel?.update = {
                DispatchQueue.main.async { [weak self] in
                    //if it is animating, stop
                    self?.refreshControl.endRefreshing()
                    self?.activityIndicator?.stopAnimating()
                    //reload tableview
                    self?.tableView.reloadData()
                }
            }
        }
        //If the viewModel is empty, we fetch it, otherwise
        if viewModel.isEmpty {
            viewModel?.populateViewModel { success in
                if !success {
                    //there was a network error
                    //show an action sheet telling the user to fix internet and pull to refresh
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        let ac = UIAlertController(title: "No connection", message: "Please fix internet and pull to refresh", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        ac.addAction(action)
                        
                        self?.delegate?.presentController(from: self!, viewController: ac, animated: true)
                        //                        self?.present(ac, animated: true, completion: nil)
                        //if I try to stop the spinners for network error these in another order I get UI problems, either the spinners dont show or show longer
                        self?.refreshControl.endRefreshing()
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            //if here, that means there was a pull to refresh but that the viewModel isnt empty so, spinner is stopped
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
//MARK: - Private Methods
extension RootView {
    //Setup Activity Indicator
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        tableView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -150).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RootTableCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        NSLayoutConstraint.activate( [
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    //Pull to refresh action
    @objc private func refreshTableView(_ sender: UIRefreshControl) {
        viewModelSetupAndFetch()
    }
    //MARK: DataSource method to create cells
    private func createCellForViewModel(at indexPath: IndexPath) -> RootTableCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RootTableCell
        let section = RootViewSections.allCases[indexPath.section]
        
        switch section {
        case .Favorites:
            cell.viewModel = viewModel?.favViewModels[indexPath.row]
        case .OtherContacts:
            cell.viewModel = viewModel?.otherViewModels[indexPath.row]
        }
        return cell
    }
}

//MARK: - TableView DataSource Methods
extension RootView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = RootViewSections.allCases[section]
        switch section {
        case .Favorites:
            return viewModel?.favViewModels?.count ?? 0
        case .OtherContacts:
            return viewModel?.otherViewModels?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createCellForViewModel(at: indexPath)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return RootViewSections.allCases.count
    }
}

//MARK: - TableView Delegate Methods
extension RootView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = RootViewSections.allCases[section]
        return section.rawValue
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Instantiate DetailViewController
        let detailViewController = DetailViewController()
        //Set its ViewModel
        detailViewController.viewModel = viewModel?.getModel(for: indexPath)
        
        //Segue to new VC
        delegate?.pushController(from: self, viewController: detailViewController, animated: true)
        //        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


