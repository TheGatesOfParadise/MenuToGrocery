

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
                self?.getFavorites()
                self?.getGroceryList()
            }
            .store(in: &cancellables)
    }
    
    //MARK: meal plan operations
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
    
    func updateMealPlanWith(_ recipe: Recipe) {
        guard let recipeId = recipe.id else { return }
        
        do {
            try store.collection(mealPlanPath).document(recipeId).setData(from: recipe)
        } catch {
            fatalError("Unable to update \(recipe.label) in Mealplan: \(error.localizedDescription).")
        }
    }
    
    //Add recipe to mealplan
    func add(_ recipe: Recipe) {
        do {
            _ = try store.collection(mealPlanPath).addDocument(from:recipe )
        } catch {
            fatalError("Unable to add \(recipe.label) to Mealplan: \(error.localizedDescription).")
        }
    }
    
    //MARK: gavorite recipes operations
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
    
    //add RecipeByCuisineType to favorites
    func add(_ recipeByCuisine: RecipeByCuisineType) {
        do {
            _ = try store.collection(favoritesPath).addDocument(from: recipeByCuisine)
        } catch {
            fatalError("Unable to add \(recipeByCuisine.cuisineType) to Faborites: \(error.localizedDescription).")
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
    
    func removeCuisineFromFavorites(_ recipeByCuisine: RecipeByCuisineType){
        guard let recipeByCuisineId = recipeByCuisine.id else { return }
        
        store.collection(favoritesPath).document(recipeByCuisineId).delete { error in
            if let error = error {
                print("Unable to remove \(recipeByCuisine.cuisineType) from Favorites: \(error.localizedDescription)")
            }
        }
    }
    
    func emptyFavorites(){
        for favoriteCuisine in favorites{
            removeCuisineFromFavorites(favoriteCuisine)
        }
    }
    
    //MARK: grocery list operations
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
    
    //Add GroceryCategory to grocery list
    func add(_ groceryCategory: GroceryCategory) {
        do {
            _ = try store.collection(groceryListPath).addDocument(from: groceryCategory)
        } catch {
            fatalError("Unable to add \(groceryCategory.name) to GroceryList: \(error.localizedDescription).")
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
    
    func removeGroceryCategory(_ groceryCategory: GroceryCategory) {
        guard let groceryCategoryId = groceryCategory.id else { return }
        
        store.collection(groceryListPath).document(groceryCategoryId).delete { error in
            if let error = error {
                print("Unable to remove \(groceryCategory.name) from Grocery list: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: combined operations, such as add recipe, it also add its ingredients to grocery list
    func addRecipeToMealPlan(_ recipe: Recipe) {
        guard let _ = recipe.id else {return}
        
        //batch
        // Get new write batch
        let batch = store.batch()
        
        //add recipe to mealPlan
        let mealPlanRef = store.collection(mealPlanPath).document()
        do {
            try _ = batch.setData(from: recipe, forDocument: mealPlanRef)
        } catch {
            fatalError("Unable to add \(recipe.label) to Mealplan: \(error.localizedDescription).")
        }
        
        //translate recipe to groceryItems, then add it to a temporary grocery list
        let groceryItems = recipe.ingredients.compactMap { GroceryItem(category: $0.foodCategory, name: $0.food, quantity: $0.quantity, measure: $0.measure, recipe: recipe)}
        var tempGroceryList = groceryList
    outerloop: for item in groceryItems {
    innerloop: for index in 0..<tempGroceryList.count {
                if tempGroceryList[index].name == item.category {
                    tempGroceryList[index].groceryItems.append(item)
                    break outerloop
                }
            }
            tempGroceryList.append(GroceryCategory(name: item.category, groceryItems: [item]))
        }
        
        //update/add category to repository's grocery list
        for index in 0..<tempGroceryList.count{
            if let exisingCategory = groceryList.first(where: {$0.name == tempGroceryList[index].name}) {
                if exisingCategory.groceryItems.count == tempGroceryList[index].groceryItems.count {continue}
                
                
               // let newItems = tempGroceryList[index].groceryItems.filter { !exisingCategory.groceryItems.contains($0) }
                
                
                //existing category with new grocery items
                let groceryRef = store.collection(groceryListPath).document(exisingCategory.id!)
                //batch.updateData(["groceryItems": FieldValue.arrayUnion({...newItems}())], forDocument: groceryRef)
                batch.deleteDocument(groceryRef)
          /*      do {
                    try _ = batch.setData(from: tempGroceryList[index], forDocument: groceryRef)
                } catch {
                    fatalError("Unable to update \(exisingCategory.name) to grocery list: \(error.localizedDescription).")
                } */
                //batch.updateData(<#T##fields: [AnyHashable : Any]##[AnyHashable : Any]#>, forDocument: groceryRef)
          
            }
           // else {
                //brand new category in grocery list
                let groceryRef = store.collection(groceryListPath).document()
                do {
                    try _ = batch.setData(from: tempGroceryList[index], forDocument: groceryRef)
                } catch {
                    fatalError("Unable to add \(recipe.label) to Mealplan: \(error.localizedDescription).")
                }
            //}
        }
        
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error adding recipe - \(err)")
            } else {
                print("Batch operation for adding recipe succeeded.")
            }
        }
        
    }
    
    func emptyGroceryList() {
        for category in groceryList {
            removeGroceryCategory(category)
        }
    }
    
    func sortAndCleanGroceryList() {
        for index in 0..<groceryList.count {
            if groceryList[index].groceryItems.count == 0 {
                groceryList.remove(at: index)
            } else {
                groceryList[index].groceryItems.sort(by: {$0.name < $1.name})
            }
        }
        groceryList.sort(by: {$0.name.capitalized < $1.name.capitalized})
        
    }
    
    func toggleGroceryItem(item:GroceryItem, category:GroceryCategory){
        let groceryRef = store.collection(groceryListPath).document(category.id!)
        
        var newCategory = category
        var newItem = item
        newItem.bought.toggle()
        newCategory.groceryItems.removeAll(where: {$0 == item})
        newCategory.groceryItems.append(newItem)
        
        let batch = store.batch()
        
        batch.deleteDocument(groceryRef)
        do {
            try _ = batch.setData(from: newCategory, forDocument: groceryRef)
        } catch {
            fatalError("Unable to toggle \(item.name) to grocery list: \(error.localizedDescription).")
        }
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error toggle \(item.name) - \(err)")
            } else {
                print("Batch operation for toggle \(item.name) succeeded.")
            }
        }
    }
    
}


struct SimpleCategory {
    let id:String
    let name:String
}
