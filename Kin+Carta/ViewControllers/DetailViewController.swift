//
//  DetailViewController.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 22/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //TableView Reuse Identifiers
    let userProfileMainID = "userProfileCellID"
    let userInfoCellID = "userInfoCellID"
    
    //UI Elements
    var tableView: UITableView!
    
    //Data Source
    var viewModel: ContactViewModel! {
        didSet {
            setupNavBar()
        }
    }
    
    //MARK: - View Controller Life-cycle methods
    override func loadView() {
        super.loadView()
        tableView = UITableView(frame: .zero, style: .plain)
        
        view = tableView
        
        setupTableView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()    
    }
}

//MARK: - TableView DataSource Methods
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.propertyDictionary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createCellForDetail(at: indexPath)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

//MARK: - TableView Delegate Methods
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Private Methods
extension DetailViewController {
    //Set up navigation bar
    private func setupNavBar() {
        if viewModel.isFavorite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteFill"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteEmpty"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        }
    }
    //Toggle favorites
    @objc private func toggleFavorite(_ sender: UIBarButtonItem) {
        if viewModel.isFavorite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteEmpty"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteFill"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        }
        viewModel.isFavorite.toggle()
    }
    //Setup the TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserProfileCell.self, forCellReuseIdentifier: userProfileMainID)
        tableView.register(UserInfoCell.self, forCellReuseIdentifier: userInfoCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userid")
    }
    
    //MARK: DataSource method to create cells
    private func createCellForDetail(at indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        case 0: //first row, picture+name+company
            let cell = tableView.dequeueReusableCell(withIdentifier: userProfileMainID, for: indexPath) as! UserProfileCell
            cell.cellViewModel = viewModel
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: userInfoCellID, for: indexPath) as! UserInfoCell
           
            //The property dictionary lists the available properties to display that arent nil
            //get the property to the corresponding cell (property 0 is name but that is handled in another case)
            let property = viewModel.propertyDictionary[indexPath.row]
            //create an object to pass to the cell
            var userCellInfoVM = UserInfoVM(headerLabel: property.key, valueLabel: property.value)
            
            //add some logic to extract the suffix from the property header to specify the type of phone number
            if userCellInfoVM.headerLabel.starts(with: "Phone") {
                if let range = userCellInfoVM.headerLabel.range(of: "Phone") {
                    userCellInfoVM.detailLabel = String(userCellInfoVM.headerLabel[range.upperBound...])
                }
                //if it was a phone property, make the header 'Phone'
                userCellInfoVM.headerLabel = "Phone"
            }
            //assign to the cell object
            cell.userInfoCellVM = userCellInfoVM
            
            return cell
        }
    }
}
