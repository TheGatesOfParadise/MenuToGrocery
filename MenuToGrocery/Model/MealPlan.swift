//
//  MealPlan.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation


///Represent recipes belong to the same cuisine type
///property `id` -  unique cuisine type
///       `recipes`  -- an array of recipes
struct RecipeByCuisineType: Identifiable, Equatable {

    //id is the cuisine type
    let id:  String
    var recipes: [Recipe]
    
    ///sample Chinese recipes
    static func sampleChineseFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(id: "chinese", recipes: [Recipe.sample(index: 1),Recipe.sample(index: 1), Recipe.sample(index: 1)])
    }
    
    ///Compare two cuisine by name
    static func == (lhs: RecipeByCuisineType, rhs: RecipeByCuisineType) -> Bool {
        lhs.id == rhs.id
    }
    
    ///sample Ameircan recipes
    static func sampleAmericanFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(id: "american", recipes: [Recipe.sample(index: 0),Recipe.sample(index: 1),Recipe.sample(index: 2)])
    }
    
    ///sample French recipes
    static func sampleFrenchFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(id: "french", recipes: [Recipe.sample(index: 2),Recipe.sample(index: 2),Recipe.sample(index: 2)])
    }
    
    ///check if a recipe is in this cuisine
    ///In parameter `recipe` -- the recipe to be checked
    ///Return `Bool` -- if recipe is in this cuisine, return true, otherwise return false
    func has(_ recipe: Recipe) -> Bool {
        if  recipe.mainCuisineType.compare(id, options: .caseInsensitive) == .orderedSame {
            for recipeFromMealPlan in recipes {
                if recipeFromMealPlan == recipe {
                    return true
                }
            }
        } else {
            return false
        }
        return false
    }
     
    mutating func remove(_ recipe: Recipe) {
        if let index = recipes.firstIndex(of: recipe) {
            recipes.remove(at: index)
        }
    }
    
}
struct FavoritRecipes {
    var recipeList: [RecipeByCuisineType]
    
    static func sample() -> FavoritRecipes {
        return FavoritRecipes(recipeList: [RecipeByCuisineType.sampleAmericanFood(),
                                           RecipeByCuisineType.sampleChineseFood(),
                                           RecipeByCuisineType.sampleFrenchFood()])
    }
    
    static func empty() -> FavoritRecipes {
        return FavoritRecipes(recipeList: [RecipeByCuisineType]())
    }
}

struct Groceries {
    var items: [Ingredient]
}
