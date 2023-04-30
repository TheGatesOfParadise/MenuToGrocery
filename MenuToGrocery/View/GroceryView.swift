//
//  GroceryView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI

struct GroceryView: View {
    @ObservedObject var mealviewModel = MealPlanViewModel.shared
    @ObservedObject var groceryListViewModel = GroceryListViewModel.shared
    @State var isOn = false  //TODO
    @State var selectedRecipe : Recipe? = nil
    @State var alertPresented = false
    
    var body: some View {
        //ScrollView{
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
                            .frame(width:30, height: 30)
                    })
                    .disabled(groceryListViewModel.groceryList.count == 0)
                    .alert(isPresented: $alertPresented, content: {
                        Alert(title: Text("Are you sure to empty grocery list?"),
                              primaryButton: .default(Text("Yes"),action: {
                            groceryListViewModel.empty()
                        }),
                              secondaryButton: .cancel(Text("Cancel")))
                    })
                }
                
                List{
                    ForEach(groceryListViewModel.groceryList) { categoryViewModel in
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

//https://sarunw.com/posts/swiftui-checkbox/#:~:text=Checkbox%20in%20SwiftUI%20is%20just,checkbox)%20.
struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {

            // 2
            configuration.isOn.toggle()

        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(.black)

                configuration.label
            }
        })
    }
}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryView()
    }
}
