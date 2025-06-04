//
//  Note+RecipeFileType.swift
//  FoodStuff
//
//  Created by Dylan Elliott on 4/6/2025.
//

import DylKit
import Foundation

extension Note {
    var recipeFileType: RecipeFileType {
        switch fileExtension {
        case "md": .markdown
        case "cook": .cookFile
        default: .unknown(fileExtension)
        }
    }
    
}

enum RecipeFileType {
    case markdown
    case cookFile
    case unknown(String)
}
