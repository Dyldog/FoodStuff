//
//  Step+Text.swift
//  FoodStuff
//
//  Created by Dylan Elliott on 4/6/2025.
//

import CookInSwift

extension Step {
    var text: String {
        directions.map { item in
            switch item {
            case let text as TextItem: text.value
            case let ingredient as Ingredient: ingredient.name
            case let equipment as Equipment: equipment.name
            case let timer as Timer: "\(timer.quantity) \(timer.units)"
            default: "UNKNOWN (\(item.description))"
            }
        }
        .joined()
    }
}
