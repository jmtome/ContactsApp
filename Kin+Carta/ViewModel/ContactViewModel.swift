//
//  ContactViewModel.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 23/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

protocol ContactViewModelUpdated {
    func didUpdate(_ viewModel: ContactViewModel)
}

class ContactViewModel {

    //Updater
    var updated: ContactViewModelUpdated?
   
    //Private property
    private var contact: Contact!
    
    
    //MARK: - Public Properties
    var id = UUID()
    var propertyDictionary: [(key: String, value: String)] = []
       
    var imageURL: String? {
        return contact.largeImageURL
    }
    var name: String? {
        return contact.name
    }
    var companyName: String? {
        return contact.companyName
    }
    var isFavorite: Bool {
        get {
            return contact.isFavorite
        }
        set {
            contact.isFavorite = newValue
            updated?.didUpdate(self)
        }
    }
    var email: String? {
        return contact.emailAddress.lowercased()
    }
    var birthday: String? {
        var date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        date = formatter.date(from: contact.birthdate)!
        formatter.dateStyle = .long
        
        return formatter.string(from: date)
    }
    var phoneHome: String? {
        return contact.phone.home?.toPhoneNumber()
    }
    var phoneWork: String? {
        return contact.phone.work?.toPhoneNumber()
    }
    var phoneMobile: String? {
        return contact.phone.mobile?.toPhoneNumber()
    }
    var address: String? {
        let street = contact.address.street.capitalized
        let city = contact.address.city.capitalized
        let state = contact.address.state.uppercased()
        let zip = contact.address.zipCode
        let country = contact.address.country.rawValue.uppercased()
        
        return  """
        \(street)
        \(city), \(state) \(zip), \(country)
        """
    }
    
    //MARK: Init
    init(with contact: Contact) {
        self.contact = contact
        setPropertyArray()
    }
    
    //MARK: Private Methods
    
    //This method makes a property array to then iterate over with the detailViewController with a tableview, the array it creates only contains non-nil items, name should always exist.
    private func setPropertyArray() {
       
        propertyDictionary.append((key: "Name", value: name ?? ""))

        if let phoneHome = phoneHome {
            propertyDictionary.append((key: "PhoneHome", value: phoneHome))
        }
        if let phoneWork = phoneWork {
            propertyDictionary.append((key: "PhoneWork", value: phoneWork))
        }
        if let phoneMobile = phoneMobile {
            propertyDictionary.append((key: "PhoneMobile", value: phoneMobile))
        }
        if let address = address {
            propertyDictionary.append((key: "Address", value: address))
        }
        if let birthday = birthday {
            propertyDictionary.append((key: "Birthday", value: birthday))
        }
        if let email = email {
            propertyDictionary.append((key: "Email", value: email))
        }
    }
    
}
