//
//  SwiftUIView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/22/23.
//

import SwiftUI

struct RecipeView: View {
    //@ObservedObject var searchViewModel = SearchViewModel.shared
    @ObservedObject var mealViewModel = MealPlanViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    var recipe: Recipe
    var body: some View {
        
        VStack {
            HStack {
                Button("Save to Meal Plan") {
                        mealViewModel.add(recipe)
                        dismiss()
                       }
               .buttonStyle(GrowingButton())
               .disabled(mealViewModel.has(recipe))
                
                Image(systemName: "heart")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 35, height: 30)
                    .padding(.leading, 20)
            }
            .padding(.top, 15)
            
            Text("\(recipe.label)")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
            Text("Cuisine: \(recipe.mainCuisineType.capitalized)") //TODO: check if this optional field
                .font(.system(size: 20, design: .rounded))
            Text("Calories: \(Int(recipe.calories))")
            Text("Prepare time: \(Int(recipe.totalTime)) mins")
            
            AsyncImage(
                url: URL(string: "\(recipe.images.small.url)"),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                },
                placeholder: {
                    Text("Loading...")
                        .frame(maxWidth: 200, maxHeight: 200)
                }
            )
            .padding()
            
            
    
            List {
                // 1
                Section("Ingredients") {
                    ForEach(recipe.ingredients) { ingredient in
                        HStack{
                            Text(ingredient.text.capitalized)
                                .foregroundColor(.blue)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding([.leading,.trailing],10 )
            
            Spacer()
            
            Button("Instructions") {
                    
                    //mealViewModel.add(recipe)
                   }
           .buttonStyle(GrowingButton())
            
            Spacer()
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe.sample(index: 0))
    }
}
