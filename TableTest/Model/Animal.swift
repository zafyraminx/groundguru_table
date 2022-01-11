//
//  Animal.swift
//  TableTest
//
//  Created by Michael Angelo Zafra on 1/10/22.
//

import Foundation

struct Animals: Codable {
    var animals:[Animal]
}

struct Animal: Codable {
    var name:String
    var description:String? = nil
}
