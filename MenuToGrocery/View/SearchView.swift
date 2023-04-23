//
//  SearchView.swift
//  Unit 9 Content
//
//  Created by Mom macbook air on 3/29/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel = SearchViewModel.shared
    //@ObservedObject var mealViewModel = MealPlanViewModel.shared
    //@ObservedObject var favoriteViewModel = FavoriteViewModel.shared
    
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
                    .padding(.leading, 50)
                
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
                Text("Cuisine stype:")
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
                Text("Meal stype:")
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
            
            //if searchViewModel.dishName != "" {
                List{
                    ForEach(searchViewModel.result.hits) { hit in
                        smallRecipeView(item: hit)
                        .onTapGesture {
                            selectedRecipe = hit.recipe
                            //singleMenuSheetIsPresented.toggle()
                        }
                    }
                }
            //}
        }
        .sheet(item: $selectedRecipe) { item in     // activated on selected item
            RecipeView(recipe: item)   //TODO: !
                .presentationDetents([.large])
        }
       
    }
}

struct smallRecipeView: View {
    let item : Hit
   
    var body: some View {
        
        HStack {
            AsyncImage(
                url: URL(string: "\(item.recipe.image)"),
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
                Text("\(item.recipe.label)")
                    .bold()
                Text("Cuisine: \(item.recipe.mainCuisineType)") //TODO: check if this optional field
                Text("Calories: \(Int(item.recipe.calories))")
               
            }
            Spacer()
        }
        .frame(width: UIScreen.screenWidth - 20)
        .border(.gray, width: 5)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
