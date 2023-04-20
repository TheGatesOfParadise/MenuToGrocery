//
//  FavoriteViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/18/23.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    
    @Published var favorite: MealPlan = MealPlan.sample()
    static let shared = FavoriteViewModel()
    
    private init() {
    }
    
    
    func getFavorites() {
        
    }
}

