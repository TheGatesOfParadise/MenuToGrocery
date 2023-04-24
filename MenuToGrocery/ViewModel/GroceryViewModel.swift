//
//  GroceryViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/23/23.
//

import Foundation


class GroceryViewModel: ObservableObject {
    
    @Published var groceryList = [GroceryItem]()
    let mealPlan =  MealPlan.sample()
    static let shared = GroceryViewModel()
    
    private init() {
    }
    
    func add(_ recipe:Recipe){
        var itemIsAdded = false
        for ingredient in recipe.ingredients {
            itemIsAdded = false
            for index in 0..<groceryList.count {
                if groceryList[index].category == ingredient.foodCategory {
                    itemIsAdded = true
                    groceryList[index].category
                }
            }
            
        }
    }
    
    func remove(_ recipe:Recipe) {
        for ingredient in recipe.ingredients {
            
        }
    }
    
    func add(_ grocery: GroceryItem) {
        
    }
    
    func remove(_ grocery: GroceryItem) {
        
    }
    
}
