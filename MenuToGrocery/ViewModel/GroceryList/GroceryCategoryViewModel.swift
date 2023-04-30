//
//  GroceryCategoryViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/29/23.
//
import Foundation
import Combine

class GroceryCategoryViewModel: ObservableObject, Identifiable, Hashable {
    
    
    private let groceryListRepository = FirebaseRepository()
    @Published var groceryCategory: GroceryCategory
    private var cancellables: Set<AnyCancellable> = []
    
    var id = ""
    
    init(groceryCategory: GroceryCategory) {
        self.groceryCategory = groceryCategory
        $groceryCategory
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    static func == (lhs: GroceryCategoryViewModel, rhs: GroceryCategoryViewModel) -> Bool {
        lhs.groceryCategory.name ==  rhs.groceryCategory.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(groceryCategory.name)
    }
}

