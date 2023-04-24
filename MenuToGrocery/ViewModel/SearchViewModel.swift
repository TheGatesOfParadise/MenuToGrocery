
import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var geoCode = "..."
    @Published var result = RecipeResponse.sample()
    static let shared = SearchViewModel()
    @Published var dishName = ""
    
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
        self?.result = response
        if self?.result.hits.count ?? -1 > 0 {
            self?.dishName = self?.result.hits[0].recipe.label ?? "empty"
        }
    }
    .store(in: &self.cancellables)
    }
}
