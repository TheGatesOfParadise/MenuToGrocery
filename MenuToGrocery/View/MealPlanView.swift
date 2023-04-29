//
//  MealPlanView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI
let recipeWidth = 120.0
let deleteSignWidth = 15.0

let layout = [
    GridItem(.flexible(minimum: 100)),
    GridItem(.flexible(minimum: 100)),
    GridItem(.flexible(minimum: 100))
]

struct MealPlanView: View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    @State var alertPresented = false
    
    var body: some View {
        
        VStack{
            HStack {
                Text("Meal Plan")
                //.font(.custom("AmericanTypewriter-Bold", fixedSize: 36))
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .padding()
                
                Button(action: {
                    alertPresented.toggle()
                }, label: {
                    Text("Empty")
                        .bold()
                })
                .disabled(viewModel.mealPlan.count == 0)
                .alert(isPresented: $alertPresented, content: {
                    Alert(title: Text("Are you sure to empty meal plan?"),
                          primaryButton: .default(Text("Yes"),action: {
                        viewModel.emptyRecipe()
                    }),
                          secondaryButton: .cancel(Text("Cancel")))
                })
            }
            RecipeGrid()

        }
    }
}

struct RecipeGrid:  View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    @State var selectedRecipe : Recipe? = nil
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: layout, content: {
                ForEach(viewModel.mealPlan, id: \.self) { recipeViewModel in
                    VStack {
                        Text("\(recipeViewModel.recipe.label)")
                            .font(.system(size: 12))
                            .frame(width: recipeWidth, height: 20)
                            .truncationMode(.tail)
                        RecipeSquareView(recipe:recipeViewModel.recipe)
                            .onTapGesture {
                                selectedRecipe = recipeViewModel.recipe
                            }
                    }
                    .sheet(item: $selectedRecipe) { item in     // activated on selected item
                        RecipeView(recipe: item)   //TODO: !
                            .presentationDetents([.large])
                    }
                }
            })
        }
        
        
        
        
    }
}

struct RecipeSquareView: View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    let recipe: Recipe
    var body: some View {
        ZStack{
            AsyncImage(
                url: URL(string: "\(recipe.images.small.url)"),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: recipeWidth, maxHeight: recipeWidth)
                    
                },
                placeholder: {
                    Text("Loading...")
                        .frame(maxWidth: recipeWidth, maxHeight: recipeWidth)
                }
            )
            
            //delete sign
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        viewModel.remove(recipe)
                    },
                           label: {
                        Image(systemName: "multiply")
                            .resizable()
                            .frame(width:deleteSignWidth, height:deleteSignWidth)
                            .foregroundColor(Color.white)
                        
                    })
                    .background(.blue.opacity(0.6))
                    .cornerRadius(40)
                    //.padding(.bottom, 10)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                }
                Spacer()
            }
            .frame(width: recipeWidth, height: recipeWidth)
        }
    }
}

struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView()
    }
}
