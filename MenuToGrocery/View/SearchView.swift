//
//  SearchView.swift
//  Unit 9 Content
//
//  Created by Mom macbook air on 3/29/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel = SearchViewModel.shared
    
    
    @State var recipeSearchPhrase = ""
    @State var selectedCuisineType = "empty"
    let cuisineOptions = ["empty", "American", "Asian", "British"]
    @State var selectedMealType = "empty"
    let mealOptions = ["empty", "Dinner", "Lunch", "Breakfast","Snack"]
    //@State var singleMenuSheetIsPresented = false
    @State var selectedRecipe : Recipe? = nil
    //@State private var singleMenuSheetIsPresented: String? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                TextField("Enter recipe name", text: $recipeSearchPhrase)
                    .padding(.leading, 5)
                
                Button(action: {
                    searchViewModel.getRecipe(search: recipeSearchPhrase,
                                              cuisineType: selectedCuisineType,
                                              mealType: selectedMealType)
                },
                       label: {
                    Text("Search")
                        .bold()
                })
                .padding(.trailing, 30)
                .disabled(recipeSearchPhrase == "")
            }
            .padding(.top, 10)
            .padding(.bottom,10)
            .border(.blue)
            .padding(30)
            
            HStack {
                Text("Cuisine Type:")
                    .padding(.leading, 40)
                Spacer()
                
                Picker("Cuisine Type", selection: $selectedCuisineType) {
                    ForEach(cuisineOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 200)
            }
            
            
            HStack {
                Text("Meal Type:")
                    .padding(.leading, 40)
                Spacer()
                
                Picker("Meal Type", selection: $selectedMealType) {
                    ForEach(mealOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 200)
            }
            
            Spacer()
            
            List{
                ForEach(searchViewModel.recipes) { recipe in
                    smallRecipeView(recipe: recipe, selectedRecipe: $selectedRecipe)
                }
            }
        }
        .sheet(item: $selectedRecipe) { item in     // activated on selected item
            RecipeView(recipe: item)   //TODO: !
                .presentationDetents([.large])
        }
    }
}

struct smallRecipeView: View {
    let recipe : Recipe
    @Binding var selectedRecipe: Recipe?
    
    var body: some View {
        
        HStack {
            HStack {
                AsyncImage(
                    url: URL(string: "\(recipe.image)"),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100, maxHeight: 100)
                    },
                    placeholder: {
                        Text("Loading...")
                            .frame(maxWidth: 100, maxHeight: 100)
                    }
                )
                .padding()
                
                Spacer()
                VStack {
                    Text("\(recipe.label)")
                        .bold()
                    Text("Cuisine: \(recipe.mainCuisineType)") //TODO: check if this optional field
                    Text("Calories: \(Int(recipe.calories))")
                    
                }
                Spacer()
            }
            .onTapGesture {
                selectedRecipe = recipe
            }
            
            VStack {
                AddToMealPlanAndFavoriteButtons(recipe: recipe)
            }
            .padding(.trailing, 10)
        }
        .frame(width: UIScreen.screenWidth - 20)
        .border(.gray, width: 5)
    }
}

///single out this view not only for  reduce redundacy of code between search view and recipe view
///it also helps to centralize the location where mealplan and grocery list are updated
struct AddToMealPlanAndFavoriteButtons: View {
    @ObservedObject var mealViewModel = MealPlanViewModel.shared
    @ObservedObject var favoriteViewModel = FavoriteViewModel.shared
    @ObservedObject var groceryListViewModel = GroceryListViewModel.shared
    var recipe: Recipe
    
    var body: some View {
        //add to meal plan button
        Button(action: {
            if mealViewModel.has(recipe) {
                mealViewModel.remove(recipe)
                //groceryListViewModel.remove(recipe)
            } else {
                mealViewModel.add(recipe)
                //groceryListViewModel.add(recipe)
            }
        }, label: {
            Image(mealViewModel.has(recipe) ? "mealPlan_red" : "mealPlan_green")
                .resizable()
                .frame(width:roundCircleButtonWidth, height: roundCircleButtonWidth)
                .clipShape(Circle())
            
        })
        .buttonStyle(.borderless)
        .padding(1)
        .clipShape(Circle())
        
        //add to favorite button
        Button(action: {
            if favoriteViewModel.has(recipe) {
                favoriteViewModel.remove(recipe)
            } else {
                favoriteViewModel.add(recipe)
                
            }
        }, label: {
            Image(systemName: favoriteViewModel.has(recipe) ? "heart.fill" : "heart")
                .resizable()
                .foregroundColor(favoriteViewModel.has(recipe) ? .red : .green)
                .frame(width: roundCircleButtonWidth - 6, height: roundCircleButtonWidth - 6)
        })
        .buttonStyle(.borderless)
        .padding(1)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
