//
//  ContactsViewModel.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 22/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class ContactsViewModel {
    
    //MARK: - Private Properties
    //This property gets set only when the json is acquired from internet, but once it creates allViewModels its unused.
    private var contacts: [Contact]! {
           didSet {
               allViewModels = contacts.map({ (contact) -> ContactViewModel in
                   let contactViewModel = ContactViewModel(with: contact)
                   //assign each VM's update protocol property to be responsibility of the ContactsViewModel class
                   contactViewModel.updated = self
                   return contactViewModel
               })
           }
       }
    //This property serves as the root of all view models but its private, the gettable properties are the favorites and the others
    private var allViewModels: [ContactViewModel]! {
        didSet {
            isEmpty = false
            favViewModels = allViewModels.filter { $0.isFavorite }
            otherViewModels = allViewModels.filter { !$0.isFavorite }
            update?()

        }
    }
    private(set) var isEmpty: Bool = true

    //MARK: - Public Properties
    var favViewModels: [ContactViewModel]!
    var otherViewModels: [ContactViewModel]!
    
    //Updating Closure, to be implemented by the view-controller
    var update: (() -> ())?

    //MARK: - Public Methods
    
    func populateViewModel(completion: ((Bool)-> Void)? = nil ) {
        NetworkManager.shared.JSONFetchRequest(with: Constants.contactsURL) { [weak self] (result: Result<[Contact], NetworkError>) in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts.sorted { $0.name < $1.name }
                completion?(true)
            case .failure(let error):
                print("no internet")
                print("error \(error)")
                completion?(false)
            }
        }
    }
    
    //TODO: - Gets model for indexpath,
    //this method should probably go in the datasource, in the same place as the indexPath that it's called with, but for now i will leave it here.
    func getModel(for indexPath: IndexPath) -> ContactViewModel {
        let section = RootViewSections.allCases[indexPath.section]
        switch section {
        case .Favorites:
            return favViewModels[indexPath.row]
        case .OtherContacts:
            return otherViewModels[indexPath.row]
        }
    }
}
//MARK: - Implementation of method update from contactVM to contactsVM
extension ContactsViewModel: ContactViewModelUpdated {
    func didUpdate(_ viewModel: ContactViewModel) {
        //here I find the viewModel that was updated inside of the allViewModels array and I update it there, consequently i have to update the favorites/other arrays
        let index = allViewModels.firstIndex { $0.id == viewModel.id }
        //I modify the viewmodel from the viewModel list
        allViewModels[index!] = viewModel
        //I call the closure update method
        update?()
    }
}
