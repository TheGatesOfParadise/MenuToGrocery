//
//  MealPlanViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation
import Combine

class MealPlanViewModel: ObservableObject {
    @Published var mealRepository = FirebaseRepository()
    @Published var mealPlan = [RecipeViewModel]()
    //@Published var mealPlan = [Recipe.sample(index: 1)]
    static let shared = MealPlanViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        
        mealRepository.$mealPlan.map { recipes in
          recipes.map(RecipeViewModel.init)
        }
        .assign(to: \.mealPlan, on: self)
        .store(in: &cancellables)
    }
        
    func add(_ recipe: Recipe?) {
        guard let recipe =  recipe else {return}

        //mealPlan.append(recipe)
        mealRepository.add(recipe) //TODO:check
    }
    
    ///Check if a cuisine is in the meal plan, if it's true, then return the recipe list that belong to the cuisine type
    ///In paremeter : `cuisine` -- the cuisine type to be checked
    ///Return: `RecipeByCuisineType` -- optional.  Only if the cuisine is in the meal plan, return a list of recipes, otherwise return nil
    ///TODO; 
    func has(_ recipe: Recipe) -> Bool {
        let recipes = mealPlan.compactMap{$0.recipe}
        return recipes.contains(recipe)
    }

    func remove (_ recipe: Recipe) {
        //mealRepository.removeFromMealPlan(recipe)
        //mealPlan.removeAll(where: {$0 == recipe})
    }
    
    func emptyRecipe() {
        //mealRepository.emptyMealPlan()
        //mealPlan.removeAll()
        
    }
}
