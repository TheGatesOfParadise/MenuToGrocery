//
//  SwiftUIView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/22/23.
//

import SwiftUI

let roundCircleButtonWidth = 30.0

struct RecipeTopView: View {
    @ObservedObject var favoriteViewModel = FavoriteViewModel.shared
    @ObservedObject var mealViewModel = MealPlanViewModel.shared
    //@Environment(\.dismiss) var dismiss
    
    var recipe: Recipe
    var body: some View {
        
        VStack {
            HStack {
                AddToMealPlanAndFavoriteButtons(recipe: recipe)
            }
            .padding(.top, 10)
            
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

            Spacer()
        }
    }
}

struct BackgroundButton: ButtonStyle {
    var isDisabled = false
    var backGroundColor: Color = .blue
    var shape: any Shape = Rectangle()
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isDisabled ? .gray : backGroundColor)
            .foregroundColor(.white)
            .disabled(isDisabled)
            //.clipShape(shape)
            //.scaleEffect(configuration.isPressed ? 1.1 : 1)
            //.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RecipeTopView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTopView(recipe: Recipe.sample(index: 0))
    }
}
