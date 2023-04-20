//
//  MealPlanView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import SwiftUI

struct MealPlanView: View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    
    var body: some View {
        
        VStack{
            Text("Meal Plan")
                .bold()
            
            ForEach(viewModel.mealPlan.cuisineTypes) { cuisine in
                VStack{
                    Text("\(cuisine.id.rawValue)")
                        .bold()
                    HStack {
                        ForEach(cuisine.recipes) { r in
                            VStack{
                                Text("\(r.label)")
                                //Text("\(r.image)")
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
                                .padding()
                            }
                        }
                    }
                }
                
            }
        }
    }
}

struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView()
    }
}
