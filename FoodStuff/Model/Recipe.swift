//
//  Recipe.swift
//  FoodStuff
//
//  Created by Dylan Elliott on 4/6/2025.
//

import Foundation

struct Recipe {
    typealias Section = (String?, [String])
    
    let ingredients: [Section]
    let steps: [Section]
    
    var hasErrors: Bool {
        guard ingredients.isEmpty == false || steps.isEmpty == false else { return true }
        func stringHasErrors(_ string: String?) -> Bool {
            (string ?? "").lowercased().contains("error")
        }
        
        func sectionHasErrors(_ sections: [Section]) -> Bool {
            sections.any { section in
                stringHasErrors(section.0) || section.1.any { stringHasErrors($0) }
            }
        }
        
        return sectionHasErrors(ingredients) || sectionHasErrors(steps)
    }
    
    init(ingredients: [Section], steps: [Section]) {
        self.ingredients = ingredients
        self.steps = steps
    }
    
    init(ingredientStrings: [String], stepStrings: [String]) {
        self.ingredients = [(nil, ingredientStrings.map { string in
            Self.ingredientString(from: string)
        })]
        self.steps = [(nil, stepStrings.map { string in
            Self.stepString(from: string)
        })]
    }
    
    static func ingredientString(from string: String) -> String {
        guard let match = Self.INGREDIENT_REGEX.firstMatch(in: string, options: .anchored)
        else { return "ERROR DECODING" }
        return string.substring(with: match.range(at: 1))
    }
    
    static func stepString(from string: String) -> String {
        guard let match = Self.STEP_REGEX.firstMatch(in: string, options: .anchored)
        else { return "ERROR DECODING" }
        return string.substring(with: match.range(at: 1))
    }
}

private extension Recipe {
    private static let INGREDIENT_REGEX = try! NSRegularExpression(
        pattern: "- (.+)",
        options: .anchorsMatchLines
    )
    
    private static let STEP_REGEX = try! NSRegularExpression(
        pattern: "\\d+\\. (.+)",
        options: .anchorsMatchLines
    )
}
