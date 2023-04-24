//
//  Groceroy.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/23/23.
//

import Foundation

struct GroceryItem {
    let category: String
    let name: String
    let quantity: Double
    let measure: String?
    let recipe: Recipe?
    
    static func garlic() -> GroceryItem {
        return GroceryItem(category: "vegetables", name: "garlic", quantity: 3.0, measure: "clove", recipe: Recipe.sample(index: 0))
    }
    
    static func onion() -> GroceryItem {
        return GroceryItem(category: "vegetables", name: "onion", quantity: 1.0, measure: nil, recipe: Recipe.sample(index: 0))
    }
    
    static func oliveOil() -> GroceryItem {
        return GroceryItem(category: "Oils", name: "olive oil", quantity: 0.25, measure: "cup", recipe: Recipe.sample(index: 0))
    }
    
    static func cannedVegetables() -> GroceryItem {
        return GroceryItem(category: "canned vegetables", name: "tomatoes", quantity: 28.00, measure: "ounce", recipe: Recipe.sample(index: 0))
    }
    
    static func salt() -> GroceryItem {
        return GroceryItem(category: "condiments and sauces", name: "salt", quantity:0.00, measure: nil, recipe: Recipe.sample(index: 0))
    }
}



