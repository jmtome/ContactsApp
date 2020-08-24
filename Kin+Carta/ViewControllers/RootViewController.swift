//
//  RootViewController.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 21/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//



import UIKit

class RootViewController: UIViewController {
    
    //UI Elements
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
    //TableView Reuse Identifiers
    let reuseIdentifier = "RootCellID"
    
    //Data Source
    var viewModel: ContactsViewModel! = ContactsViewModel()
    
    //Refresher
    var refreshControl = UIRefreshControl()
    
    //MARK: - View Controller Life-cycle methods
    override func loadView() {
        super.loadView()
        tableView = UITableView(frame: .zero, style: .plain)
        view = tableView
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModelSetupAndFetch()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        setupActivityIndicator()
    }
    
}

//MARK: - TableView DataSource Methods
extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = RootViewSections.allCases[section]
        
        switch section {
        case .Favorites:
            return viewModel.favViewModels?.count ?? 0
        case .OtherContacts:
            return viewModel.otherViewModels?.count ?? 0
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
extension RootViewController: UITableViewDelegate {
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
        detailViewController.viewModel = viewModel.getModel(for: indexPath)
        
        //Segue to new VC
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


//MARK: - Private Methods
extension RootViewController {
    
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
    //Setup TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RootTableCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
    }
    
    //Pull to refresh action
    @objc private func refreshTableView(_ sender: UIRefreshControl) {
        viewModelSetupAndFetch()
    }
    
    // Initial page settings
    private func viewModelSetupAndFetch()  {
        //whenever the update closure is triggered inside the ContactsViewModel class, the tableview will be reloaded
        if viewModel.update == nil {
            viewModel.update = {
                DispatchQueue.main.async { [weak self] in
                    //if it is animating, stop
                    self?.refreshControl.endRefreshing()
                    self?.activityIndicator.stopAnimating()
                    //reload tableview
                    self?.tableView.reloadData()
                }
            }
        }
        //If the viewModel is empty, we fetch it, otherwise
        if viewModel.isEmpty {
            viewModel.populateViewModel { success in
                if !success {
                    //there was a network error
                    //show an action sheet telling the user to fix internet and pull to refresh
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        let ac = UIAlertController(title: "No connection", message: "Please fix internet and pull to refresh", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        ac.addAction(action)
                        
                        self?.present(ac, animated: true, completion: nil)
                        //if I try to stop the spinners for network error these in another order I get UI problems, either the spinners dont show or show longer
                        self?.refreshControl.endRefreshing()
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            //if here, that means there was a pull to refresh but that the viewModel isnt empty so, spinner is stopped
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        } 
    }
    //MARK: DataSource method to create cells
    private func createCellForViewModel(at indexPath: IndexPath) -> RootTableCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RootTableCell
        let section = RootViewSections.allCases[indexPath.section]
        
        switch section {
        case .Favorites:
            cell.viewModel = viewModel.favViewModels[indexPath.row]
        case .OtherContacts:
            cell.viewModel = viewModel.otherViewModels[indexPath.row]
        }
        return cell
    }
}
