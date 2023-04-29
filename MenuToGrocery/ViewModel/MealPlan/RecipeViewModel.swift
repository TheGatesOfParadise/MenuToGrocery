
import Foundation
import Combine

class RecipeViewModel: ObservableObject, Identifiable, Hashable {
    private let firebaseRepository = FirebaseRepository()
    @Published var recipe: Recipe
    private var cancellables: Set<AnyCancellable> = []
    
    var id = ""
    
    init(recipe: Recipe) {
        self.recipe = recipe
        $recipe
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    //TODO: following 2 methods are not used, check
    func update(recipe: Recipe) {
        firebaseRepository.updateMealPlanWith(recipe)
    }
    
    func remove() {
        firebaseRepository.removeFromMealPlan(recipe)
    }
    
    static func == (lhs: RecipeViewModel, rhs: RecipeViewModel) -> Bool {
        lhs.recipe == rhs.recipe
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(recipe)
    }
}
