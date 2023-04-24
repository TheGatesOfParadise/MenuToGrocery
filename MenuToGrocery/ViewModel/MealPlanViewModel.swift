//
//  MealPlanViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation

class MealPlanViewModel: ObservableObject {
    
    //@Published var mealPlan = [Recipe]()
    @Published var mealPlan = [Recipe.sample(index: 1)]
    static let shared = MealPlanViewModel()
    
    private init() {
    }
    
        
    func add(_ recipe: Recipe?) {
        guard let recipe =  recipe else {return}

        mealPlan.append(recipe)
    }
    
    
    ///Check if a cuisine is in the meal plan, if it's true, then return the recipe list that belong to the cuisine type
    ///In paremeter : `cuisine` -- the cuisine type to be checked
    ///Return: `RecipeByCuisineType` -- optional.  Only if the cuisine is in the meal plan, return a list of recipes, otherwise return nil
    ///TODO; 
    func has(_ recipe: Recipe) -> Bool {
        return mealPlan.contains(recipe)
    }


    func remove (_ recipe: Recipe) {
        mealPlan.removeAll(where: {$0 == recipe})
    }
    

        
    func emptyRecipe() {
        mealPlan.removeAll()
    }
        
    
}
