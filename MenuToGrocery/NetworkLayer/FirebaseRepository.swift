

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class FirebaseRepository: ObservableObject {
    @Published var loading = false
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
        let batch = store.batch()
        for recipe in mealPlan{
            guard let recipeId = recipe.id else { return }
            let document = store.collection(mealPlanPath).document(recipeId)
            batch.deleteDocument(document)
        }
        batch.commit(){ err in
            if let err = err {
                print("Error emptying meal plan- \(err)")
            } else {
                print("Batch operation for emptying meal plan succeeded.")
            }
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
        let batch = store.batch()
        for favoriteCuisine in favorites{
            guard let recipeByCuisineId = favoriteCuisine.id else { return }
            
            let document = store.collection(favoritesPath).document(recipeByCuisineId)
            batch.deleteDocument(document)
        }
        batch.commit() { err in
            if let err = err {
                print("Error emptying favorites - \(err)")
            } else {
                print("Batch operation for emptying favorites succeeded.")
            }
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
    func addRecipe(_ recipe: Recipe) {
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
        
        print("lalala---before translation of recipe -----------")
        for indi in recipe.ingredients {
            print("   \(indi.foodCategory):\(indi.food) - \(indi.quantity)")
        }
        
        
        //translate recipe to groceryItems, then add it to a temporary grocery list
        let groceryItems = recipe.ingredients.compactMap { GroceryItem(category: $0.foodCategory, name: $0.food, quantity: $0.quantity, measure: $0.measure, recipe: recipe)}
        
        let groceryDictionary = Dictionary(grouping: groceryItems, by: { (element: GroceryItem) in
            return element.category
        })
        
        print("lalala---dictionary test start")
        for (key,value) in groceryDictionary {
            print("\(key)")
            for item in value {
                print("     \(item.name)")
            }
        }
        
        print("lalala---array test start")
        //let arr = myDict.map { "\($0.key) \($0.value)" }
        var newRecipeGroceryList = groceryDictionary.compactMap{GroceryCategory(name: "\($0.key)", groceryItems: $0.value)}
        
        for category in newRecipeGroceryList {
            print("\(category.name)")
            for item in category.groceryItems {
                print("     \(item.name)")
            }
        }
        
        
        //update/add category to repository's grocery list
        for index in 0..<newRecipeGroceryList.count{
            if let exisingCategory = groceryList.first(where: {$0.name == newRecipeGroceryList[index].name}) {
                
                //delete existing category
                let groceryRef = store.collection(groceryListPath).document(exisingCategory.id!)
                batch.deleteDocument(groceryRef)
                
                //merge grocery items in the same category
                newRecipeGroceryList[index].groceryItems = newRecipeGroceryList[index].groceryItems + exisingCategory.groceryItems
            }
            
            //add new category back to store
            let groceryRef = store.collection(groceryListPath).document()
            do {
                try _ = batch.setData(from: newRecipeGroceryList[index], forDocument: groceryRef)
            } catch {
                fatalError("Unable to add \(recipe.label) to Mealplan: \(error.localizedDescription).")
            }
            
            
        }
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error adding recipe - \(err)")
            } else {
                print("Batch operation for adding recipe succeeded.")
            }
        }
        
        print("lalala---finally groceryList looks like this-----------")
        for index in 0..<groceryList.count{
            print("\(groceryList[index].name):\(groceryList[index].groceryItems.count)")
            for item in groceryList[index].groceryItems {
                print("     \(item.name) - \(item.quantity)")
            }
        }
    }
    
    func removeRecipe(_ recipe: Recipe) {
        guard let recipeId = recipe.id else {return}
        
        //batch
        // Get new write batch
        let batch = store.batch()
        
        //delete recipe from mealPlan
        let recipeRef = store.collection(mealPlanPath).document(recipeId)
        batch.deleteDocument(recipeRef)
        
        
    
        print("hahaha---before translation of recipe -----------")
        for indi in recipe.ingredients {
            print("   \(indi.foodCategory):\(indi.food) - \(indi.quantity)")
        }
        
        //translate recipe to groceryItems, then add it to a temporary grocery list
        let groceryItems = recipe.ingredients.compactMap { GroceryItem(category: $0.foodCategory, name: $0.food, quantity: $0.quantity, measure: $0.measure, recipe: recipe)}
        
        let groceryDictionary = Dictionary(grouping: groceryItems, by: { (element: GroceryItem) in
            return element.category
        })
        
        print("hahaha---dictionary test start")
        for (key,value) in groceryDictionary {
            print("\(key)")
            for item in value {
                print("     \(item.name)")
            }
        }
        
        print("hahaha---array test start")
        //let arr = myDict.map { "\($0.key) \($0.value)" }
        var newRecipeGroceryList = groceryDictionary.compactMap{GroceryCategory(name: "\($0.key)", groceryItems: $0.value)}
        
        for category in newRecipeGroceryList {
            print("\(category.name)")
            for item in category.groceryItems {
                print("     \(item.name)")
            }
        }
        
        print("hahaha---existing grocery list  start")
        for category in groceryList {
            print("\(category.name)")
            for item in category.groceryItems {
                print("     \(item.name)")
            }
        }
        
        
        //update/remove category to repository's grocery list
        for index in 0..<newRecipeGroceryList.count{
            if var exisingCategory = groceryList.first(where: {$0.name == newRecipeGroceryList[index].name}) {
                
                //delete existing category
                let groceryRef = store.collection(groceryListPath).document(exisingCategory.id!)
                batch.deleteDocument(groceryRef)
                
                if newRecipeGroceryList[index].name == "canned vegetables" {
                    print("stop here")
                }
                
                //merge grocery items in the same category
                //newRecipeGroceryList[index].groceryItems = newRecipeGroceryList[index].groceryItems.filter { !exisingCategory.groceryItems.contains($0) }
                exisingCategory.groceryItems = exisingCategory.groceryItems.filter { !newRecipeGroceryList[index].groceryItems.contains($0) }
                
                //add back upated category with less grocery items back to store
                if exisingCategory.groceryItems.count > 0 {
                    let groceryRef = store.collection(groceryListPath).document()
                    do {
                        try _ = batch.setData(from: exisingCategory, forDocument: groceryRef)
                    } catch {
                        fatalError("Unable to delete \(recipe.label) to grocery list: \(error.localizedDescription).")
                    }
                }
            }
        }
            
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error deleting recipe - \(err)")
            } else {
                print("Batch operation for deleting recipe succeeded.")
            }
        }
        
    }
    
    //delete all docs in a colleciton using batch is referenced from this post:
    //https://stackoverflow.com/questions/53089517/how-to-delete-all-documents-in-collection-in-firestore-with-flutter
    func emptyGroceryList() {
        let batch = store.batch()
        
        //empty a category from grocery list
        for category in groceryList {
            guard let groceryCategoryId = category.id else { return }
            
            let document = store.collection(groceryListPath).document(groceryCategoryId)
            batch.deleteDocument(document)
        }
        batch.commit(){ err in
            if let err = err {
                print("Error to empty grocey list - \(err)")
            } else {
                print("Batch operation for emptying grocery list succeeded.")
            }
        }

    }

    func sortAndCleanGroceryList() {
        print("#1")
        for index in 0..<groceryList.count {
            print("   \(groceryList[index].name):\(groceryList[index].groceryItems.count)")
        }
        
        for index in 0..<groceryList.count {
            if index < groceryList.count {
                if groceryList[index].groceryItems.count == 0 {
                    groceryList.remove(at: index)
                } else {
                    groceryList[index].groceryItems.sort(by: {$0.name < $1.name})
                }
            }
        }
        groceryList.sort(by: {$0.name.capitalized < $1.name.capitalized})
        
        print("#2")
        for index in 0..<groceryList.count {
            print("   \(groceryList[index].name):\(groceryList[index].groceryItems.count)")
        }
        
        updateView()
        
    }
    
    func toggleGroceryItem(item:GroceryItem, category:GroceryCategory){
        var groceryRef = store.collection(groceryListPath).document(category.id!) //TODO: !
        
        var groceryItems:[GroceryItem] = category.groceryItems
        var newItem = item
        newItem.bought.toggle()
        
        groceryItems = groceryItems.filter( {$0 != item})
        groceryItems.append(newItem)
        

        let batch = store.batch()
        //let encodedGroceryItems = groceryItems.compactMap { try? Firestore.Encoder().encode($0) }
        batch.deleteDocument(groceryRef)
        groceryRef = store.collection(groceryListPath).document()
        do {
            try _ = batch.setData(from: GroceryCategory(name: category.name, groceryItems: groceryItems), forDocument: groceryRef)
        } catch {
            fatalError("Unable to toggle \(item.name) to grocery list: \(error.localizedDescription).")
        }
        
        batch.commit(){ err in
            if let err = err {
                print("Error toggling grocery item- \(err)")
            } else {
                print("Batch operation for toggle grocery item succeeded.")
            }
        }
        /*
        groceryRef.updateData([
            "groceryItems" : FieldValue.arrayUnion(encodedGroceryItems)
        ]){ err in
            if let err = err {
                print("Error to toggle grocey list - \(err)")
            } else {
                print("Toggle operation for a grocery item succeeded.")
            }
        }
        */
        print("#3")
        for index in 0..<groceryList.count {
            print("   \(groceryList[index].name):\(groceryList[index].groceryItems.count)")
        }
        
        sortAndCleanGroceryList()
    }
    
    func updateView(){
        self.objectWillChange.send()
    }
    
}


struct SimpleCategory {
    let id:String
    let name:String
}
