//
//  GroceryView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI

struct GroceryView: View {
    @ObservedObject var groceryListViewModel = GroceryListViewModel.shared
    @State var selectedRecipe : Recipe? = nil
    @State var alertPresented = false
    
    var body: some View {

            VStack {
                HStack{
                    Text("Grocery List")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .padding()
                    
                    Button(action: {
                        alertPresented.toggle()
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width:25, height: 25)
                    })
                    .disabled(groceryListViewModel.groceryList.count == 0)
                    .alert(isPresented: $alertPresented, content: {
                        Alert(title: Text("Are you sure to empty grocery list?"),
                              primaryButton: .default(Text("Yes"),action: {
                            groceryListViewModel.emptyGroceryList()
                        }),
                              secondaryButton: .cancel(Text("Cancel")))
                    })
                }
                
                List{
                    //ForEach(groceryListViewModel.groceryList) { categoryViewModel in
                    //for index in 0..<groceryListViewModel.groceryList.count {
                    ForEach(groceryListViewModel.groceryList.indices, id: \.self) { index in
                            categoryView(categoryViewModel: groceryListViewModel.groceryList[index], selectedRecipe: $selectedRecipe)
                    }
                }
                Spacer()
            }
        .onAppear{
            groceryListViewModel.sortAndClean()
        }
        .sheet(item: $selectedRecipe) { item in     // activated on selected item
            RecipeView(recipe: item)   //TODO: !
                .presentationDetents([.large])
        }
    }
}

struct categoryView: View {
    @ObservedObject var groceryListViewModel = GroceryListViewModel.shared
    var categoryViewModel:GroceryCategoryViewModel
    @Binding var selectedRecipe: Recipe?
    
    var body: some View {
        Section("\(categoryViewModel.groceryCategory.name)") {
            VStack (alignment: .leading){
     
                ForEach(categoryViewModel.groceryCategory.groceryItems) {item in
                   
                        HStack{
                            Button(action: {
                                groceryListViewModel.toggle(item)
                            },
                                   label: {Image(systemName: item.bought ? "checkmark.square.fill" : "square")
                            })
                            .buttonStyle(.borderless)
                            
                            Text(item.name)
                            Spacer()
                            Text(item.quantityDisplay)
                            Text(item.measure ?? "")
                        }
                    
                    .foregroundColor(.black)
                    .onTapGesture {
                        selectedRecipe = item.recipe
                    }
                }
            }
        }
        
    }
}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryView()
    }
}
