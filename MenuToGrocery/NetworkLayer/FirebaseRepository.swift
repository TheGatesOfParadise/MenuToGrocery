

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class FirebaseRepository: ObservableObject {

  private let mealPlanPath: String = "mealPlan"
  private let favoritesPath: String = "favorites"
  private let groceryListPath: String = "groceryList"
  private let store = Firestore.firestore()
    
  @Published var mealPlan = [Recipe]()
  @Published var favorites = [RecipeByCuisineType]()
  @Published var groceryList = [GroceryCategory]()
    
    var userId = ""
    private let authenticationService = AuthenticationService()
    private var cancellables: Set<AnyCancellable> = []
    
    
    
    init() {
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)

        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.getMealPlan()
                //self?.getFavorites()
                //self?.getGroceryList()
            }
            .store(in: &cancellables)
    }
    
    func getMealPlan() {
      store.collection(mealPlanPath)
        //.whereField("userId", isEqualTo: userId)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            print("Error getting cards: \(error.localizedDescription)")
            return
          }

          self.mealPlan = querySnapshot?.documents.compactMap { document in
              var recipe : Recipe? = try? document.data(as: Recipe.self)
              recipe?.id = document.documentID
              return recipe
          } ?? []
        }
    }
    
    func getFavorites() {
      store.collection(favoritesPath)
        //.whereField("userId", isEqualTo: userId)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            print("Error getting cards: \(error.localizedDescription)")
            return
          }

          self.favorites = querySnapshot?.documents.compactMap { document in
            try? document.data(as: RecipeByCuisineType.self)
          } ?? []
        }
    }
    
    func getGroceryList() {
      store.collection(groceryListPath)
        //.whereField("userId", isEqualTo: userId)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            print("Error getting cards: \(error.localizedDescription)")
            return
          }

          self.groceryList = querySnapshot?.documents.compactMap { document in
            try? document.data(as: GroceryCategory.self)
          } ?? []
        }
    }
    
    //Add recipe to mealplan
    func add(_ recipe: Recipe) {
      do {
        var newRecipe = recipe
          //newRecipe.userId = userId
        _ = try store.collection(mealPlanPath).addDocument(from: newRecipe)
      } catch {
          fatalError("Unable to add \(recipe.label) to Mealplan: \(error.localizedDescription).")
      }
    }
    
    //add RecipeByCuisineType to favorites
    func add(_ recipeByCuisine: RecipeByCuisineType) {
      do {
        var newrRecipeByCuisine = recipeByCuisine
          //newMealPlan.userId = userId  //TODO: why need it?
        _ = try store.collection(favoritesPath).addDocument(from: newrRecipeByCuisine)
      } catch {
          fatalError("Unable to add \(recipeByCuisine.cuisineType) to Faborites: \(error.localizedDescription).")
      }
    }
    
    //Add GroceryCategory to grocery list
    func add(_ groceryCategory: GroceryCategory) {
      do {
        var newGroceryCategory = groceryCategory
          //newMealPlan.userId = userId  //TODO: why need it?
        _ = try store.collection(groceryListPath).addDocument(from: newGroceryCategory)
      } catch {
          fatalError("Unable to add \(groceryCategory.name) to GroceryList: \(error.localizedDescription).")
      }
    }

    
    func updateMealPlanWith(_ recipe: Recipe) {
      guard let recipeId = recipe.id else { return }

      do {
          try store.collection(mealPlanPath).document(recipeId).setData(from: recipe)
      } catch {
          fatalError("Unable to update \(recipe.label) in Mealplan: \(error.localizedDescription).")
      }
    }
    
    func updateFavoritesWith(_ recipeByCuisine: RecipeByCuisineType) {
      guard let recipeByCuisineId = recipeByCuisine.id else { return }

      do {
        try store.collection(favoritesPath).document(recipeByCuisineId).setData(from: recipeByCuisine)
      } catch {
          fatalError("Unable to update \(recipeByCuisine.cuisineType) in Favorites: \(error.localizedDescription).")
      }
    }
    
    func updateGroceryListWith(_ groceryCategory: GroceryCategory) {
      guard let groceryCategoryId = groceryCategory.id else { return }

      do {
        try store.collection(groceryListPath).document(groceryCategoryId).setData(from: groceryCategory)
      } catch {
          fatalError("Unable to update \(groceryCategory.name) in Grocery list: \(error.localizedDescription).")
      }
    }

    func removeFromMealPlan(_ recipe: Recipe) {
        guard let recipeId = recipe.id else { return }

        store.collection(mealPlanPath).document(recipeId).delete { error in
        if let error = error {
            print("Unable to remove \(recipe.label) from Mealplan: \(error.localizedDescription)")
        }
      }
    }
    
    func emptyMealPlan(){
        for recipe in mealPlan{
            removeFromMealPlan(recipe)
        }
    }
}
