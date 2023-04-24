//
//  Groceroy.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/23/23.
//

import Foundation

struct GroceryItem : Identifiable {
    let id = UUID()
    let category: String
    let name: String
    let quantity: Double
    let measure: String?
    let recipe: Recipe

    func toString() -> String {
        //return String("\(name)  \(quantity)  \(measure ?? "") for \(recipe.label)")
        return String("\(name)  \(quantity)  \(measure ?? "")")
    }
    
    static func garlic() -> GroceryItem {
        return GroceryItem(category: "vegetables", name: "garlic", quantity: 3.0, measure: "clove", recipe: Recipe.sample(index: 0))
    }
    
    static func onion() -> GroceryItem {
        return GroceryItem(category: "vegetables", name: "onion", quantity: 1.0, measure: nil, recipe: Recipe.sample(index: 0))
    }
    
    static func oliveOil() -> GroceryItem {
        return GroceryItem(category: "Oils", name: "olive oil", quantity: 0.25, measure: "cup", recipe: Recipe.sample(index: 0))
    }
    
    static func cannedVegetable() -> GroceryItem {
        return GroceryItem(category: "canned vegetables", name: "tomatoes", quantity: 28.00, measure: "ounce", recipe: Recipe.sample(index: 0))
    }
    
    static func salt() -> GroceryItem {
        return GroceryItem(category: "condiments and sauces", name: "salt", quantity:0.00, measure: nil, recipe: Recipe.sample(index: 0))
    }
}

struct GroceryCategory: Identifiable {
    let id = UUID()
    let name: String
    var groceryItems: [GroceryItem]
    
    static func sampleVegetable() -> GroceryCategory {
        return GroceryCategory(name: "vegetables", groceryItems: [GroceryItem.onion(),GroceryItem.garlic()])
    }
    
    static func sampleCannedVegetable() -> GroceryCategory {
        return GroceryCategory(name: "canned vegetables", groceryItems: [GroceryItem.cannedVegetable()])
    }
    
}

typealias GroceryList = [GroceryCategory]

extension GroceryItem: Hashable {
    static func == (lhs: GroceryItem, rhs: GroceryItem) -> Bool {
        lhs.category == rhs.category &&
        lhs.name == rhs.name &&
        lhs.quantity == rhs.quantity &&
        lhs.measure == rhs.measure
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
        hasher.combine(name)
        hasher.combine(quantity)
        hasher.combine(measure)
    }
}


