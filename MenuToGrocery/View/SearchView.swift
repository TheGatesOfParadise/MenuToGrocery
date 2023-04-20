//
//  SearchView.swift
//  Unit 9 Content
//
//  Created by Mom macbook air on 3/29/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel = SearchViewModel.shared
    @ObservedObject var mealViewModel = MealPlanViewModel.shared
    @ObservedObject var favoriteViewModel = FavoriteViewModel.shared
    
    @State var recipeSearchPhrase = ""
    @State var selectedCuisineType = "empty"
    let cuisineOptions = ["empty", "American", "Asian", "British"]
    @State var selectedMealType = "empty"
    let mealOptions = ["empty", "Dinner", "Lunch", "Breakfast","Snack"]
    @State var singleMenuSheetIsPresented = false
    @State var selectedRecipe : Recipe =  Recipe.sample(index:0)
    
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
                Text("Cuisine stype:\(selectedCuisineType)")
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
                Text("Meal stype:\(selectedMealType)")
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
                            singleMenuSheetIsPresented.toggle()
                        }
                    }
                }
            //}
        }
        .sheet(isPresented: $singleMenuSheetIsPresented) {
            singleRecipeView(recipe: selectedRecipe)
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

struct singleRecipeView: View {
    let recipe: Recipe
    var body: some View {
        
        VStack {
            HStack {
                Button("Save to Meal Plan") {
                           //print("Button pressed!")
                            //close sheet, back to search screen
                       }
               .buttonStyle(GrowingButton())
                
                Image(systemName: "heart")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 35, height: 35)
                    .padding(.leading, 20)
            }
            .padding(.top, 15)
            
            Spacer()
            
            Text("\(recipe.label)")
                .bold()
            
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
            Text("Cuisine: \(recipe.mainCuisineType)") //TODO: check if this optional field
            Text("Calories: \(Int(recipe.calories))")
            
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
