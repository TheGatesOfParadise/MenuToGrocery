//
//  MealPlan.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation

struct RecipeByCuisineType: Identifiable {
    let id = UUID()
    
    var cuisineType: String
    var recipes: [Recipe]
    
    static func sampleChineseFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(cuisineType: "chinese", recipes: [Recipe.sample(index: 1)])
    }
    
    static func sampleAmericanFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(cuisineType: "american", recipes: [Recipe.sample(index: 0)])
    }
    
    static func sampleFrenchFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(cuisineType: "french", recipes: [Recipe.sample(index: 2)])
    }
}

struct MealPlan {
    var recipeList: [RecipeByCuisineType]
    
    static func sample() -> MealPlan {
        return MealPlan(recipeList: [RecipeByCuisineType.sampleAmericanFood(),
                                     RecipeByCuisineType.sampleChineseFood(),
                                     RecipeByCuisineType.sampleFrenchFood()])
    }
}

struct FavoritRecipes {
    var recipeList: [RecipeByCuisineType]
    
    static func sample() -> FavoritRecipes {
        return FavoritRecipes(recipeList: [RecipeByCuisineType.sampleAmericanFood(),
                                           RecipeByCuisineType.sampleChineseFood(),
                                           RecipeByCuisineType.sampleFrenchFood()])
    }
}

struct Groceries {
    var items: [Ingredient]
}
