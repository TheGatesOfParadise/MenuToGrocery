//
//  GroceryViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/23/23.
//

import Foundation


class GroceryViewModel: ObservableObject {
    
    //@Published var groceryList = [GroceryCategoy]()
    @Published var groceryList = [GroceryCategory.sampleVegetable(), GroceryCategory.sampleCannedVegetable()]
    //let mealPlan =  MealPlan.sample()
    static let shared = GroceryViewModel()
    
    private init() {
    }
    
    func remove(_ recipe:Recipe) {
        //generate grocelistItem list from recipe
        let groceryItems = recipe.ingredients.compactMap { GroceryItem(category: $0.foodCategory, name: $0.food, quantity: $0.quantity, measure: $0.measure, recipe: recipe)}
        
        for item in groceryItems {
            remove(item)
        }
    }
    
    func add(_ grocery: GroceryItem) {
        for index in 0..<groceryList.count {
            if groceryList[index].name == grocery.category {
                groceryList[index].groceryItems.append(grocery)
                groceryList[index].groceryItems.sort(by: {$0.name < $1.name})
                return
            }
        }
        
        groceryList.append(GroceryCategory(name: grocery.category, groceryItems: [grocery]))
    }
    
    func remove(_ grocery: GroceryItem) {
        for index in 0..<groceryList.count {
            if groceryList[index].name == grocery.category {
                groceryList[index].groceryItems.removeAll(where: {$0 == grocery})
                return
            }
        }
    }
    
    func add(_ recipe: Recipe){
        
        //generate grocelistItem list from recipe
        let groceryItems = recipe.ingredients.compactMap { GroceryItem(category: $0.foodCategory, name: $0.food, quantity: $0.quantity, measure: $0.measure, recipe: recipe)}
        
        for item in groceryItems {
            add(item)
        }
    }
    
    func translateMealPlan(_ mealPlan: [Recipe]) {
        empty()
        for recipe in mealPlan {
            add(recipe)
        }
    }
    
    func empty() {
        groceryList.removeAll()
    }
    
}
