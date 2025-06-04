//
//  ContentView.swift
//  FoodStuff
//
//  Created by Dylan Elliott on 4/6/2025.
//

import DylKit
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: RecipeListViewModel = .init()
    
    var body: some View {
        List {
            ForEach(viewModel.recipes) { recipe in
                NavigationLink {
                    RecipeDetailView(viewModel: .init(note: recipe.note, recipe: recipe.recipe))
                } label: {
                    RecipeRow(viewModel: recipe)
                }
            }
        }
        .navigationTitle("Recipes")
        .withNotesFolderSelector {
            viewModel.reload()
        }
    }
}

#Preview {
    ContentView()
}
