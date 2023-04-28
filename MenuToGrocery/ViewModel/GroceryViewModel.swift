//
//  GroceryViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/23/23.
//

import Foundation


class GroceryViewModel: ObservableObject {
    
    @Published var groceryList = [GroceryCategory]()
    //@Published var groceryList = [GroceryCategory.sampleVegetable(), GroceryCategory.sampleCannedVegetable()]
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
        if has(grocery) {return}
        
        for index in 0..<groceryList.count {
            if groceryList[index].name == grocery.category {
                groceryList[index].groceryItems.append(grocery)
                //groceryList[index].groceryItems.sort(by: {$0.name < $1.name})
                return
            }
        }
        
        groceryList.append(GroceryCategory(name: grocery.category, groceryItems: [grocery])) //TODO: test of firebase
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
    
    //rearrange grocery list
    //If a food category has 0 recipe, then remove the category.  Otherwise sort recipes by name
    //In the last sort groceryList by food category
    func sortAndClean() {
        for index in 0..<groceryList.count {
            if groceryList[index].groceryItems.count == 0 {
                groceryList.remove(at: index)
            } else {
                groceryList[index].groceryItems.sort(by: {$0.name < $1.name})
            }
        }
        groceryList.sort(by: {$0.name.capitalized < $1.name.capitalized})
    }
    
    func translateMealPlan(_ mealPlan: [Recipe]) {
        empty()
        for recipe in mealPlan {
            add(recipe)
        }
    }
    
    func toggle(_ grocery: GroceryItem) {
        if !has(grocery) {return }
        
        for index in 0..<groceryList.count {
            for i in 0..<groceryList[index].groceryItems.count {
                if groceryList[index].groceryItems[i] == grocery {
                    groceryList[index].groceryItems[i].bought.toggle()
                }
            }
        }
    }
    
    //Check if the grocery item from same recipe is already in the grocery list
    func has(_ groceryItem: GroceryItem) -> Bool {
        for category in groceryList {
            if category.groceryItems.contains(where: {$0 == groceryItem}) {
                return true
            }
        }
        
        return false
    }
    
    func empty() {
        groceryList.removeAll()
    }
    
}
