//
//  Contact.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 21/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//
import Foundation

// MARK: - Contact
struct Contact: Codable {
    var name, id: String
    var companyName: String?
    var isFavorite: Bool
    var smallImageURL, largeImageURL: String
    var emailAddress, birthdate: String
    var phone: Phone
    var address: Address
}






