//
//  Address.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 24/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//
import Foundation

// MARK: - Address
struct Address: Codable {
    var street, city, state: String
    var country: Country
    var zipCode: String
}
