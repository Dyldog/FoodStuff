//
//  RecipeListView.swift
//  FoodStuff
//
//  Created by Dylan Elliott on 4/6/2025.
//

import CookInSwift
import DylKit
import UIKit

class RecipeListViewModel: ObservableObject {
    private let notesDB: NotesDatabase = .init()
    
    var recipes: [RecipeRowModel] = []
    
    init() {
        reload()
    }
    
    func reload() {
        let notes = notesDB
            .getNotes(in: "/", filetypes: ["md", "cook"])?
            .filter { $0.title != "recipes" } ?? []
        
        recipes = notes.map { note in
            switch note.recipeFileType {
            case .markdown: decodeRecipeFromMarkdown(note)
            case .cookFile: decodeRecipeFromCookFile(note)
            case .unknown: decodeRecipeForUnknownFiletype(note)
            }
        }
        
    }
    
    private func decodeRecipeFromMarkdown(_ note: Note) -> RecipeRowModel {
        typealias RecipeSection = (String?, [String])
        var ingredients: [RecipeSection]?
        var steps: [RecipeSection]?
        
        func recipeSection(for section: NoteSection, with mapper: (String) -> String) -> RecipeSection {
            (
                section.level == 2 ? nil : section.title,
                section.lines
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
                    .filter { $0.isEmpty == false }
                    .map { mapper($0) }
            )
        }
        
        for section in note.sections {
            switch section.level {
            case 1: continue
            case 2:
                if ingredients == nil {
                    ingredients = [recipeSection(for: section, with: Recipe.ingredientString)]
                } else {
                    steps = [recipeSection(for: section, with: Recipe.stepString)]
                }
            default:
                if steps == nil {
                    ingredients?.append(recipeSection(for: section, with: Recipe.ingredientString))
                } else {
                    steps?.append(recipeSection(for: section, with: Recipe.stepString))
                }
            }
        }
        
        return .init(
            image: getImage(for: note),
            title: note.title,
            note: note,
            recipe: .init(ingredients: ingredients ?? [], steps: steps ?? [])
        )
    }
    
    private func decodeRecipeFromCookFile(_ note: Note) -> RecipeRowModel {
        let cookRecipe = try! CookInSwift.Recipe.from(text: note.contents)
        let recipe = Recipe(
            ingredients: [(nil, cookRecipe.ingredientsTable.ingredients.map { ingredient, amount in
                amount.description + " " + ingredient
            })],
            steps: [(nil, cookRecipe.steps.map { step in
                step.text
            })]
        )
        
        return .init(
            image: getImage(for: note),
            title: note.title,
            note: note,
            recipe: recipe
        )
    }
    
    private func decodeRecipeForUnknownFiletype(_ note: Note) -> RecipeRowModel {
        .init(
            image: getImage(for: note),
            title: "Unknown filetype for '\(note.filename)'",
            note: note,
            recipe: nil
        )
    }
    
    private func getImage(for note: Note) -> UIImage? {
        guard
            let (_, imageData) = notesDB.getFile(note.title + ".jpg"),
            let imageData else { return nil }
        return UIImage(data: imageData)
    }
}
