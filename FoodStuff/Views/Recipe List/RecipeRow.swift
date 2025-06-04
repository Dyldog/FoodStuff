//
//  RecipeRow.swift
//  FoodStuff
//
//  Created by Dylan Elliott on 4/6/2025.
//

import DylKit
import SwiftUI

struct RecipeRowModel {
    let image: UIImage?
    let title: String
    let note: Note
    let recipe: Recipe?
}

struct RecipeRow: View {
    let viewModel: RecipeRowModel
    
    var body: some View {
        HStack {
            if let image = viewModel.image {
                Image(image: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text(viewModel.title)
            
            Spacer()
            
            if viewModel.recipe?.hasErrors ?? true {
                TextIcon(text: "E", color: .red)
            }
            
            TextIcon(text: viewModel.note.typeIcon, color: viewModel.note.typeIconColour)
        }
    }
}

extension Note {
    var typeIcon: String {
        String(fileExtension.first ?? "?").uppercased()
    }
    
    var typeIconColour: Color {
        switch typeIcon {
        case "M": .blue
        case "C": .yellow
        case "?": .red
        default: .red
        }
    }
}

struct TextIcon: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .bold()
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 4).foregroundColor(color)
                    .frame(width: 16, height: 16)
            )
    }
}
