
import Foundation
import Combine

class RecipeByCuisineTypeViewModel: ObservableObject, Identifiable, Hashable {
    
    
    private let firebaseRepository = FirebaseRepository()
    @Published var recipeByCuisineType: RecipeByCuisineType
    private var cancellables: Set<AnyCancellable> = []
    
    var id = ""
    
    init(recipeByCuisineType: RecipeByCuisineType) {
        self.recipeByCuisineType = recipeByCuisineType
        $recipeByCuisineType
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
 /*
    func update(recipe: Recipe) {
        //firebaseRepository.updateMealPlanWith(recipe)
    }
    
    func remove() {
        //firebaseRepository.remove
    }
*/
    static func == (lhs: RecipeByCuisineTypeViewModel, rhs: RecipeByCuisineTypeViewModel) -> Bool {
        lhs.recipeByCuisineType.cuisineType ==  rhs.recipeByCuisineType.cuisineType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(recipeByCuisineType.cuisineType)
    }
}

