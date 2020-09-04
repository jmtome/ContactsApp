//
//  DetailView.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 03/09/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

//MARK: - RootViewDelegate Protocol
protocol DetailViewDelegate: class {
    func setupNavBar(from view: UIView)
}

class DetailView: UIView {
    //MARK: - Delegate
    weak var delegate: DetailViewDelegate?
    
    //TableView Reuse Identifiers
    let userProfileMainID = "userProfileCellID"
    let userInfoCellID = "userInfoCellID"
    
    //UI Elements
    var tableView: UITableView! = UITableView(frame: .zero, style: .plain)
    
    //MARK: - ViewModel Property
    var viewModel: ContactViewModel! {
        didSet {
            delegate?.setupNavBar(from: self)
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private Methods
extension DetailView {
    //MARK: - Setup TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserProfileCell.self, forCellReuseIdentifier: userProfileMainID)
        tableView.register(UserInfoCell.self, forCellReuseIdentifier: userInfoCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userid")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        NSLayoutConstraint.activate( [
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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
//MARK: - TableView DataSource Methods
extension DetailView: UITableViewDataSource {
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
extension DetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
