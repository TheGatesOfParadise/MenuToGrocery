//
//  GroceryView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI

struct GroceryView: View {
    @ObservedObject var mealviewModel = MealPlanViewModel.shared
    @ObservedObject var groceryViewModel = GroceryViewModel.shared
    @State var isOn = false  //TODO
    @State var selectedRecipe : Recipe? = nil
    
    var body: some View {
        //ScrollView{
            VStack {
                
                Text("Grocery List")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                List{
                    ForEach(groceryViewModel.groceryList) { category in
                        Section("\(category.name)") {
                            VStack (alignment: .leading){
                                ForEach(category.groceryItems) {item in
                                    Toggle(isOn: $isOn) {
                                        HStack{
                                                
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
                                    .toggleStyle(iOSCheckboxToggleStyle())
                                }

                            }
                        }
                    }
                    
                }
                Spacer()
            }
        //}
        .onAppear{
            groceryViewModel.translateMealPlan(mealviewModel.mealPlan)
            //groceryViewModel.add(Recipe.sample(index: 0))
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
