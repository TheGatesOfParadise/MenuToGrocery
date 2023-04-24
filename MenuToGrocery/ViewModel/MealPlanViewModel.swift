//
//  MealPlanViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation

class MealPlanViewModel: ObservableObject {
    
    @Published var mealPlan: MealPlan = MealPlan.empty()
    static let shared = MealPlanViewModel()
    
    private init() {
    }
    
        
    func add(_ recipe: Recipe?) {
        guard let recipe =  recipe else {return}
        
        for i in 0..<mealPlan.cuisineTypes.count {
            if  recipe.mainCuisineType == mealPlan.cuisineTypes[i].id {
                // add recipe to recipeByCuisine.recipes
                mealPlan.cuisineTypes[i].recipes.append(recipe)
                //break for loop and return
                return
            }
        }
        
        mealPlan.cuisineTypes.append(RecipeByCuisineType(id: recipe.mainCuisineType , recipes: [recipe]))
    }
    
    
    ///Check if a cuisine is in the meal plan, if it's true, then return the recipe list that belong to the cuisine type
    ///In paremeter : `cuisine` -- the cuisine type to be checked
    ///Return: `RecipeByCuisineType` -- optional.  Only if the cuisine is in the meal plan, return a list of recipes, otherwise return nil
    func hasCuisine(_ type: String) -> RecipeByCuisineType? {
        return mealPlan.cuisineTypes.first(where: {$0.id == type})
    }
   
    func has(_ recipe: Recipe) -> Bool {
        guard let recipeByCuisineType = hasCuisine(recipe.mainCuisineType) else {
            return false
        }
        
        if recipeByCuisineType.has(recipe) {
            return true
        } else {
            return false
        }
    }
    
    func remove(_ cuisine: String) {
        mealPlan.cuisineTypes.removeAll(where: {$0.id == cuisine})
        
    }
    
    func remove (_ recipe: Recipe) {
        for i in 0..<mealPlan.cuisineTypes.count {
            if  recipe.mainCuisineType == mealPlan.cuisineTypes[i].id {
                // remove recipe from recipeByCuisine.recipes
                mealPlan.cuisineTypes[i].recipes.removeAll(where : {$0 == recipe})
                
                //if nothing left for a cuisine type, remove the type entirely
                if mealPlan.cuisineTypes[i].recipes.count == 0 {
                    remove( mealPlan.cuisineTypes[i].id)
                }
                
                //break for loop and return
                return
            }
        }
        
    }
    

        
    func emptyRecipe() {
        mealPlan.cuisineTypes.removeAll()
    }
        
    
}
