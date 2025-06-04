//
//  RecipeDetailView.swift
//  FoodStuff
//
//  Created by Dylan Elliott on 4/6/2025.
//

import DylKit
import SwiftUI

class RecipeDetailViewModel: ObservableObject {
    let note: Note
    let recipe: Recipe?
    
    @Published var selectedView: RecipeDetailView.Section
    @Published var stepsCompleted: [[Bool]]
    
    init(note: Note, recipe: Recipe?) {
        self.note = note
        self.recipe = recipe
        self.selectedView = recipe == nil ? .plain : .rich
        self.stepsCompleted = recipe?.steps.map {
            Array(repeating: false, count: $0.1.count)
        } ?? []
    }
}

struct RecipeDetailView: View {
    @StateObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack {
            Picker("View", selection: $viewModel.selectedView)
                .labelsHidden()
                .pickerStyle(.segmented)
            
            switch viewModel.selectedView {
            case .rich: richView
            case .plain: plainView
            }
        }
        .navigationTitle(viewModel.note.title)
    }
    
    private var plainView: some View {
        ScrollView {
            Text(viewModel.note.contents)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var richView: some View {
        if let recipe = viewModel.recipe {
            GeometryReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if let image = viewModel.recipe?.image {
                            Image(image: image)
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight: proxy.size.width)
                                .clipped()
                        }
                        
                        VStack(alignment: .leading) {
                            if recipe.ingredients.isEmpty == false {
                                Text("Ingredients")
                                    .font(.largeTitle)
                                    .bold()
                                
                                ForEach(recipe.ingredients) { ingredientSection in
                                    if let sectionTitle = ingredientSection.0 {
                                        Text(sectionTitle)
                                            .bold()
                                    }
                                    ForEach(ingredientSection.1) { ingredient in
                                        Text("• " + ingredient)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            if recipe.steps.isEmpty == false {
                                Text("Steps")
                                    .font(.largeTitle)
                                    .bold()
                                
                                ForEach(enumerated: recipe.steps) { sectionIndex, stepSection in
                                    if let sectionTitle = stepSection.0 {
                                        Text(sectionTitle)
                                            .bold()
                                    }
                                    ForEach(enumerated: stepSection.1) { stepIndex, step in
                                        Button {
                                            viewModel.stepsCompleted[sectionIndex][stepIndex].toggle()
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .foregroundStyle(Color(white: 0.8))
                                                Text("\(stepIndex + 1). " + step)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding()
                                                    .strikethrough(viewModel.stepsCompleted[sectionIndex][stepIndex], color: .red)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

extension RecipeDetailView {
    enum Section: CaseIterable, Pickable {
        case rich
        case plain
        
        var title: String {
            switch self {
            case .rich: "Rich"
            case .plain: "Plain"
            }
        }
    }
}
