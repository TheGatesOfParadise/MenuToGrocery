//
//  MealPlanView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI

let recipeWidth = 120.0
let deleteSignWidth = 15.0

struct MealPlanView: View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    @State var selectedRecipe : Recipe? = nil
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
                .disabled(viewModel.mealPlan.cuisineTypes.count == 0)
                .alert(isPresented: $alertPresented, content: {
                    Alert(title: Text("Are you sure to empty meal plan?"),
                primaryButton: .default(Text("Yes"),action: {
                        viewModel.emptyRecipe()
                    }),
                secondaryButton: .cancel(Text("Cancel")))
                })
                
            }
            
            ScrollView(.vertical) {
                ForEach(viewModel.mealPlan.cuisineTypes) { cuisine in
                    VStack (alignment: .leading){
                        //cuisine type
                        Text("\(cuisine.id.capitalized)")
                            .font(.system(size: 24, weight: .semibold))
                        
                        //recipes belong to the cuisine
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                ForEach(cuisine.recipes) { r in
                                    
                                    VStack {
                                        Text("\(r.label)")
                                            .font(.system(size: 12))
                                            //.fixedSize(horizontal: false, vertical: false)
                                            .frame(width: recipeWidth, height: 20)
                                            .truncationMode(.tail)
                                            
                                        ZStack{
                                            AsyncImage(
                                                url: URL(string: "\(r.images.small.url)"),
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
                                            
                                            //delete button
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Button(action: {
                                                        viewModel.remove(r)
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
                                            //.border(.green, width: 1)
                                        }
                                    }
                                    //.frame(width: 150, height: 150)
                                    //.border(.blue, width: 1)
                                    .onTapGesture {
                                        selectedRecipe = r
                                    }
                                    
                                    
                                }
                                .frame(width: recipeWidth+5, height: recipeWidth+55)
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
