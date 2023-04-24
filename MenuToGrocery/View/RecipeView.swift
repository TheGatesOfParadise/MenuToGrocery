//
//  SwiftUIView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/22/23.
//

import SwiftUI

let roundCircleButtonWidth = 30.0

struct RecipeView: View {
    //@ObservedObject var searchViewModel = SearchViewModel.shared
    @ObservedObject var mealViewModel = MealPlanViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    var recipe: Recipe
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    mealViewModel.add(recipe)
                    dismiss()
                    
                }, label: {
                    Image("mealPlan")
                        .resizable()
                        .frame(width:roundCircleButtonWidth, height: roundCircleButtonWidth)
                        .foregroundColor(.red)
                        .clipShape(Circle())
                        
                })
                .padding(5)
                .background(mealViewModel.has(recipe) ? .gray : .red)
                .foregroundColor(.white)
                .disabled(mealViewModel.has(recipe))
                .clipShape(Circle())
                
                Button(action: {
                    //favortieMale.add(recipe)
                    dismiss()
                    
                }, label: {
                    Image(systemName: "heart")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: roundCircleButtonWidth - 6, height: roundCircleButtonWidth - 6)
                })
                .padding(6)
                .background(mealViewModel.has(recipe) ? .gray : .red)
                .foregroundColor(.white)
                .disabled(mealViewModel.has(recipe))
                .clipShape(Circle())
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
            
            
    
            List {
                // 1
                Section("Ingredients") {
                    ForEach(recipe.ingredients) { ingredient in
                        VStack{
                            Text(ingredient.text.capitalized)
                                .foregroundColor(.blue)
                                .fixedSize(horizontal: false, vertical: true)
                    /*
                            Text(String(format: "%.2f", ingredient.quantity))
                                .foregroundColor(.purple)
                            
                            Text(ingredient.measure ?? "empty")
                                .foregroundColor(.brown)
                            
                            Text(ingredient.food)
                                .foregroundColor(.pink)
                            
                            Text(String(format: "%.2f", ingredient.weight))
                                .foregroundColor(.green)
                            Text(ingredient.foodCategory)
                                .foregroundColor(.red)
                            Text(ingredient.foodID)
                                .foregroundColor(.black) */
                        }
                    }
                }
            }
            .padding([.leading,.trailing],10 )
            
            Spacer()
            
            
            
            Button("Instructions") {
                    
                    //mealViewModel.add(recipe)
                   }
           .buttonStyle(BackgroundButton(isDisabled: false))
            
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

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe.sample(index: 0))
    }
}
