//
//  MealPlan.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation
import FirebaseFirestoreSwift

///Represent recipes belong to the same cuisine type
///property `id` -  unique cuisine type
///       `recipes`  -- an array of recipes
struct RecipeByCuisineType: Identifiable, Equatable, Codable {
    @DocumentID var id: String?
    let cuisineType:  String
    var recipes: [Recipe]
    
    enum CodingKeys: CodingKey {
        case id
        case cuisineType
        case recipes
    }
    
    ///sample Chinese recipes
    static func sampleChineseFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(cuisineType: "chinese", recipes: [Recipe.sample(index: 1),Recipe.sample(index: 1), Recipe.sample(index: 1)])
    }
    
    ///Compare two cuisine by name
    static func == (lhs: RecipeByCuisineType, rhs: RecipeByCuisineType) -> Bool {
        lhs.cuisineType == rhs.cuisineType
    }
    
    ///sample Ameircan recipes
    static func sampleAmericanFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(cuisineType: "american", recipes: [Recipe.sample(index: 0),Recipe.sample(index: 1),Recipe.sample(index: 2)])
    }
    
    ///sample French recipes
    static func sampleFrenchFood() -> RecipeByCuisineType {
        return RecipeByCuisineType(cuisineType: "french", recipes: [Recipe.sample(index: 2),Recipe.sample(index: 2),Recipe.sample(index: 2)])
    }
    
    ///check if a recipe is in this cuisine
    ///In parameter `recipe` -- the recipe to be checked
    ///Return `Bool` -- if recipe is in this cuisine, return true, otherwise return false
    func has(_ recipe: Recipe) -> Bool {
        if  recipe.mainCuisineType.compare(cuisineType, options: .caseInsensitive) == .orderedSame {
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

typealias Mealplan = [Recipe]

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
