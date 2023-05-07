//
//  ChatGPTViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 5/7/23.
//

import Foundation
import Combine

class ChatGPTViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var geoCode = "..."
    @Published var recipes = [Recipe]()
    static let shared = ChatGPTViewModel()

    private init() {
    }
    
    
    //MARK: AccuWeather API services
    func getRecipe(search: String, cuisineType: String?, mealType: String?) {
                
        /*
         https://api.edamam.com/api/recipes/v2?type=public&
        beta=false&
         q=crawfish%20etouffee&
         app_id=60774aad&
         app_key=4ed5ca518b3756cbc0701d7501264aa8&
         ingr=5-8&
         diet=high-protein&
         cuisineType=American&
         mealType=Dinner&
         calories=100-300&
         imageSize=THUMBNAIL
         */
        var query:[String:String] = ["beta": "false",
                                     "q":search,
                                     "ingr":"5-8",
                                     //"diet":"high-protein",
                                     //"cuisineType":"American",
                                     //"mealType":"Dinner",
                                     "calories":"100-300",
                                     "imageSize":"THUMBNAIL"]
        if let t = cuisineType, !t.isEmpty, t != "empty" {
            query["cuisineType"] = cuisineType
        }
        
        if let t = mealType, !t.isEmpty, t != "empty" {
            query["mealType"] = mealType
        }
        
        EdamamNetworkManager.shared.getRecipe(endpoint: "\(EdamamNetworkManager.shared.recipeURL)",
                                          query: query,
                                          type: RecipeResponse.self)
        .sink { completion in
            switch completion {
            case .failure(let err):
                print("getRecipe Error is \(err.localizedDescription)")
            case .finished:
                print("getRecipe Finished")
                
            }
        }
    receiveValue: { [weak self] response in
        self?.recipes = response.hits.compactMap{$0.recipe}
    }
    .store(in: &self.cancellables)
    }
}

/*
/////////////////////////////
if let data = apiRequestManager.responseData {
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        if let choices = json["choices"] as? [[String: Any]] {
            if let text = choices[0]["text"] as? String {
                Text(text)
            }
        }
    }
}
*/
