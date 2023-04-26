//
//  FavoriteViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    @Published var favoritesRepository = FirebaseRepository()
    @Published var favorites = [RecipeByCuisineType]()
    /*@Published var favorites = [RecipeByCuisineType.sampleFrenchFood(),
                               RecipeByCuisineType.sampleChineseFood(),
                               RecipeByCuisineType.sampleAmericanFood()]
     */
    static let shared = FavoriteViewModel()
    
    private init() {
    }
    
    func getFavorites() {
        
    }
        
    func add(_ recipe: Recipe?) {
        guard let recipe =  recipe else {return}
        
        for i in 0..<favorites.count {
            if  recipe.mainCuisineType == favorites[i].cuisineType {
                // add recipe to recipeByCuisine.recipes
                favorites[i].recipes.append(recipe)
                //break for loop and return
                return
            }
        }
        
        
        favorites.append(RecipeByCuisineType(cuisineType: recipe.mainCuisineType , recipes: [recipe]))
        
        favoritesRepository.add(RecipeByCuisineType(cuisineType: recipe.mainCuisineType , recipes: [recipe])) //TODO: pure test for firebase
    }
    
    
    ///Check if a cuisine is in favorite meals, if it's true, then return the recipe list that belong to the cuisine type
    ///In paremeter : `cuisine` -- the cuisine type to be checked
    ///Return: `RecipeByCuisineType` -- optional.  Only if the cuisine is in the favorite meals, return a list of recipes, otherwise return nil
    func hasCuisine(_ type: String) -> RecipeByCuisineType? {
        return favorites.first(where: {$0.cuisineType == type})
    }
   
    func has(_ recipe: Recipe) -> Bool {
        guard let recipeByCuisineType = hasCuisine(recipe.mainCuisineType) else {
            return false
        }
        
        if recipeByCuisineType.has(recipe) {
            return true
        } else {
            return false
        }
    }
    
    func remove(_ cuisine: String) {
        favorites.removeAll(where: {$0.cuisineType == cuisine})
        
    }
    
    func remove (_ recipe: Recipe) {
        for i in 0..<favorites.count {
            if  recipe.mainCuisineType == favorites[i].cuisineType {
                // remove recipe from recipeByCuisine.recipes
                favorites[i].recipes.removeAll(where : {$0 == recipe})
                
                //if nothing left for a cuisine type, remove the type entirely
                if favorites[i].recipes.count == 0 {
                    remove( favorites[i].cuisineType)
                }
                
                //break for loop and return
                return
            }
        }
        
    }
    
    func emptyFavorites() {
        favorites.removeAll()
    }
        
    
}
