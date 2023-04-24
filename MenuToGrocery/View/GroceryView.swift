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
    @State var isOn = false
    
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
                                            Text(String(format: "%.1f", item.quantity))
                                                
                                            Text(item.measure ?? "")
                                        }
                                        .foregroundColor(.black)
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
            //groceryViewModel.translateMealPlan(MealPlan.sample())
            groceryViewModel.add(Recipe.sample(index: 0))
        }
    }
}

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
