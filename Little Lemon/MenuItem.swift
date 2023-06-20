//
//  MenuItem.swift
//  Little Lemon
//
//  Created by Christian Pedersen on 21/06/2023.
//

import Foundation

struct MenuItem: Decodable, Identifiable {
    let id = UUID()
    
    let title: String
    let image: String
    let price: String
}
