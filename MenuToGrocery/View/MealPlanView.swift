//
//  MealPlanView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI

struct MealPlanView: View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    @State var selectedRecipe : Recipe? = nil
    var body: some View {
        
        VStack{
            Text("Meal Plan")
                //.font(.custom("AmericanTypewriter-Bold", fixedSize: 36))
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .padding()
            
            ForEach(viewModel.mealPlan.cuisineTypes) { cuisine in
                VStack (alignment: .leading){
                    //cuisine type
                    Text("\(cuisine.id.rawValue.capitalized)")
                        .font(.system(size: 24, weight: .semibold))
                    
                    //recipes belong to the cuisine
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(cuisine.recipes) { r in
                                ZStack{
                                    VStack (alignment: .leading){
                                        Text("\(r.label)")
                                            .font(.system(size: 20))
                                        AsyncImage(
                                            url: URL(string: "\(r.image)"),
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
                                        .border(.pink, width: 5)
                                    }
                                    .onTapGesture {
                                        selectedRecipe = r
                                    }
                                    .border(.green, width: 5)
                                    
                                    //delete button
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Button(action: {
                                                viewModel.remove(r)
                                            },
                                                   label: {
                                                Image(systemName: "multiply")})
                                            
                                        }
                                        Spacer()
                                    }
                                }
                                .border(.blue, width: 5)
                                .frame(width: 250, height: 250)
                            }
                        }
                    }
                }
                .padding([.leading,.trailing], 15)
                
            }
            
            Spacer()
            Spacer()
        }
        .sheet(item: $selectedRecipe) { item in     // activated on selected item
            RecipeView(recipe: item)   //TODO: !
                .presentationDetents([.large])
        }
    }
}

struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView()
    }
}
