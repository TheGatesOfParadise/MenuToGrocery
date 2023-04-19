//
//  MealPlanViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation

class MealPlanViewModel: ObservableObject {
    
    @Published var mealPlan: MealPlan = MealPlan.sample()
    static let shared = MealPlanViewModel()
    
    private init() {
    }
    
    
    func getMealPlan() {
        
    }
    
}
