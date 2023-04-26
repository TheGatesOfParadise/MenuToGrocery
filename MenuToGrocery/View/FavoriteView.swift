//
//  FavoriteView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI

struct FavoriteView: View {
    @ObservedObject var viewModel = FavoriteViewModel.shared
    @State var selectedRecipe : Recipe? = nil
    @State var alertPresented = false
    var body: some View {
        
        VStack{
            HStack {
                Text("Favorite Meals")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .padding()
                
                Button(action: {
                    alertPresented.toggle()
                }, label: {
                    Text("Empty")
                        .bold()
                })
                .disabled(viewModel.favorites.count == 0)
                .alert(isPresented: $alertPresented, content: {
                    Alert(title: Text("Are you sure to empty favorite meals?"),
                primaryButton: .default(Text("Yes"),action: {
                        viewModel.emptyFavorites()
                    }),
                secondaryButton: .cancel(Text("Cancel")))
                })
            }
            
            ScrollView(.vertical) {
                ForEach(viewModel.favorites) { cuisine in
                    VStack (alignment: .leading){
                        //cuisine type
                        Text("\(cuisine.cuisineType.capitalized)")
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
struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
