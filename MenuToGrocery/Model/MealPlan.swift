//
//  MealPlan.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation


enum RecipeAction: String {
    case add
    case remove
    case check
}

enum CuisineType: String {
    case chinese
    case american
    case french
    case british
    case asian
    case indian
    case italian
    case caribbean
}

///Represent recipes belong to the same cuisine type
///property `id` -  unique cuisine type
///       `recipes`  -- an array of recipes
struct RecipeByCuisineType: Identifiable, Equatable {

    
    let id:  CuisineType
    var recipes: [Recipe]
    
    ///sample Chinese recipes
    static func sampleChineseFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(id: CuisineType.chinese, recipes: [Recipe.sample(index: 1)])
    }
    
    ///Compare two cuisine by name
    static func == (lhs: RecipeByCuisineType, rhs: RecipeByCuisineType) -> Bool {
        lhs.id == rhs.id
    }
    
    ///sample Ameircan recipes
    static func sampleAmericanFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(id: CuisineType.american, recipes: [Recipe.sample(index: 0)])
    }
    
    ///sample French recipes
    static func sampleFrenchFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(id: CuisineType.french, recipes: [Recipe.sample(index: 2)])
    }
    
    ///check if a recipe is in this cuisine
    ///In parameter `recipe` -- the recipe to be checked
    ///Return `Bool` -- if recipe is in this cuisine, return true, otherwise return false
    func has(_ recipe: Recipe) -> Bool {
        if  recipe.mainCuisineType.compare(id.rawValue, options: .caseInsensitive) == .orderedSame {
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


struct MealPlan {
    var cuisineTypes: [RecipeByCuisineType]
    
    static func sample() -> MealPlan {
        return MealPlan(cuisineTypes: [RecipeByCuisineType.sampleAmericanFood(),
                                     RecipeByCuisineType.sampleChineseFood(),
                                     RecipeByCuisineType.sampleFrenchFood()])
    }
    
    ///Check if a cuisine is in the meal plan, if it's true, then return the recipe list that belong to the cuisine type
    ///In paremeter : `cuisine` -- the cuisine type to be checked
    ///Return: `RecipeByCuisineType` -- optional.  Only if the cuisine is in the meal plan, return a list of recipes, otherwise return nil
    func hasCuisine(_ cuisine: String) -> RecipeByCuisineType? {
        guard let cuisineEnum = CuisineType(rawValue: cuisine) else {
            return nil
        }
                
        for recipeByCuisine in cuisineTypes {
            if  recipeByCuisine.id == cuisineEnum {
                return recipeByCuisine
            } else {
                return nil
            }
        }
        return nil
    }
   
    func hasRecipe (_ recipe: Recipe) -> Bool {
        guard let recipeByCuisineType = hasCuisine(recipe.mainCuisineType) else {
            return false
        }
        
        if recipeByCuisineType.has(recipe) {
            return true
        } else {
            return false
        }
    }
    
    mutating func remove(_ cuisine: String) {
        cuisineTypes.removeAll(where: {$0.id.rawValue == cuisine})
    }
    
    mutating func removeRecipe (_ recipe: Recipe) {
        remove(recipe.mainCuisineType)
        var recipeByCuisineType = hasCuisine(recipe.mainCuisineType)
        recipeByCuisineType?.remove(recipe)
        cuisineTypes.append(recipeByCuisineType!) //TODO, check !
    }
    
    func addRecipe(_ recipe: Recipe) {
        if !hasRecipe(recipe) {
            //add it
        }
    }
        
    mutating func emptyRecipe() {
        cuisineTypes.removeAll()
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
